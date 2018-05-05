//
//  MemeMakerViewController.swift
//  MemeMe2.0
//
//  Created by Lucas César  Nogueira Fonseca on 05/05/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit

import UIKit

class MemeMakerViewController: UIViewController {
    
    // MARK: - Views
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Buttons
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - Constraints
    
    @IBOutlet weak var shareConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoConstraint: NSLayoutConstraint!
    @IBOutlet weak var editConstraint: NSLayoutConstraint!
    
    // This variables save the initial value of the constraints
    var primaryShareConstraint: CGFloat!
    var primaryTopViewConstraint: CGFloat!
    var primaryCameraConstraint: CGFloat!
    var primaryPhotoConstraint: CGFloat!
    var primaryEditConstraint: CGFloat!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    // This variable control the menu state
    var menuIsActive: Bool = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveConstraints()
        subscribeToKeyboardNotifications()
        closedMenuConstraintsUpdate()
        topView.isHidden = true
        configureTextField(textField: topTextField, text: "TOP TEXT HERE")
        configureTextField(textField: bottomTextField, text: "BOTTOM TEXT HERE")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if menuIsActive {
            menuAnimation(activeMenu: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    private func backToMain() {
        
        topTextField.text = "TOP TEXT HERE"
        bottomTextField.text = "BOTTOM TEXT HERE"
        imageView.image = nil
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func menuAction(_ sender: Any) {
        menuAnimation(activeMenu: menuIsActive)
    }
    
    @IBAction func tapToDismisskeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func editAction(_ sender: Any) {
        // I will implement this function in the next version of this code
        let alert = UIAlertController(title: "For now, this is not working.", message: "This functionality will be available on the next version.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        backToMain()
    }
    
    @IBAction func shareAction(_ sender: Any) {
        
        let activityViewController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                
                guard let meme = Meme(topText:self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imageView.image!, memeImage: self.generateMemedImage()) else {
                    fatalError("Unable to instantiate meme")
                }
                
                MemeList.sharedInstance.addMeme(meme: meme)
                
                self.backToMain()
            }
        }
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        openPicker(sourceType: .camera)
    }
    
    @IBAction func photoAction(_ sender: Any) {
        openPicker(sourceType: .photoLibrary)
    }
    
    func openPicker(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
}


// MARK: - TextField

extension MemeMakerViewController: UITextFieldDelegate  {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
    
    func textFieldDidBeginEditing (_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            //This expression is equivalent to a IF/ELSE expression
            textField.text = textField.tag == 1 ? "BOTTOM TEXT HERE" : "TOP TEXT HERE"
        }
    }
    
    
    //Here we configure the textField Types
    private func configureTextField(textField: UITextField, text: String) {
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -4.5]
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    
}

// MARK: - GenerateMeMe

extension MemeMakerViewController {
    
    //Here i generate the meme image
    func generateMemedImage() -> UIImage {
        alphaButtons(alpha: 0)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        alphaButtons(alpha: 1)
        return memedImage
    }
}


// MARK: - ImagePicker
extension MemeMakerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



// MARK: - Animated Menu

extension MemeMakerViewController {
    
    //This function make the menu animation
    func menuAnimation(activeMenu: Bool) {
        
        //Here we set buttons disabled to user doesn't click
        enableButtons(isEnabled:false)
        
        //If the menu is closed we open the menu
        if activeMenu {
            
            topView.isHidden = false
            cancelButton.isHidden = false
            
            //Before to open the menu we need to update the constraints for don't have problems with screen rotation
            closedMenuConstraintsUpdate()
            
            //This update the viewConstraints
            self.view.layoutIfNeeded()
            
            //Here we open the menu
            topViewConstraint.constant = primaryTopViewConstraint
            
            //This block make the menu cascade animation
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                
                self.cameraButton.isHidden = false
                self.editButton.isHidden = false
                
                self.view.layoutIfNeeded()
                
                self.cameraConstraint.constant = self.primaryCameraConstraint
                self.editConstraint.constant = self.primaryEditConstraint
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }) { _ in
                    
                    self.shareButton.isHidden = false
                    self.photoButton.isHidden = false
                    
                    self.view.layoutIfNeeded()
                    
                    self.shareConstraint.constant = self.primaryShareConstraint
                    self.photoConstraint.constant = self.primaryPhotoConstraint
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.layoutIfNeeded()
                    }) { _ in
                        self.enableButtons(isEnabled:true)
                    }
                }
            }
        } else {
            
            //If the menu is already active we close the menu
            shareConstraint.constant = self.view.bounds.size.width - 16 - shareButton.bounds.size.height
            photoConstraint.constant = self.view.bounds.size.width - 16 - photoButton.bounds.size.height
            // topViewConstraint.constant = primaryTopViewConstraint
            
            //This block make the menu uncascade animation
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                
                self.shareButton.isHidden = true
                self.photoButton.isHidden = true
                
                self.view.layoutIfNeeded()
                
                self.editConstraint.constant = ((self.view.bounds.size.width - self.editButton.bounds.size.height) / 2) - 16
                self.cameraConstraint.constant = ((self.view.bounds.size.width - self.cameraButton.bounds.size.height) / 2) - 16
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }) { _ in
                    
                    self.cameraButton.isHidden = true
                    self.editButton.isHidden = true
                    
                    self.view.layoutIfNeeded()
                    
                    self.topViewConstraint.constant = (self.view.bounds.size.height - self.bottomView.bounds.size.height ) - 20
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.layoutIfNeeded()
                    }) { _ in
                        
                        self.topView.isHidden = true
                        self.enableButtons(isEnabled:true)
                    }
                }
            }
        }
        
        //Here we save the current state of the menu
        self.menuIsActive = !activeMenu
    }
    
    //This function calculate the constraints of the closed menu
    func closedMenuConstraintsUpdate() {
        topViewConstraint.constant = (self.view.bounds.size.height - bottomView.bounds.size.height ) - 20
        shareConstraint.constant = self.view.bounds.size.width - 16 - shareButton.bounds.size.height
        cameraConstraint.constant = ((self.view.bounds.size.width - cameraButton.bounds.size.height) / 2) - 16
        photoConstraint.constant = self.view.bounds.size.width - 16 - photoButton.bounds.size.height
        editConstraint.constant = ((self.view.bounds.size.width - editButton.bounds.size.height) / 2) - 16
    }
    
    func enableButtons(isEnabled: Bool) {
        shareButton.isUserInteractionEnabled = isEnabled
        menuButton.isUserInteractionEnabled = isEnabled
        photoButton.isUserInteractionEnabled = isEnabled
        cameraButton.isUserInteractionEnabled = isEnabled
        cancelButton.isUserInteractionEnabled = isEnabled
        editButton.isUserInteractionEnabled = isEnabled
    }
    
    func alphaButtons(alpha: CGFloat) {
        if alpha == 0 {
            enableButtons(isEnabled:false)
        } else {
            enableButtons(isEnabled:true)
        }
        shareButton.alpha = alpha
        menuButton.alpha = alpha
        photoButton.alpha = alpha
        cameraButton.alpha = alpha
        cancelButton.alpha = alpha
        editButton.alpha = alpha
    }
    
    //This function persist the initial constraints value
    func saveConstraints() {
        primaryEditConstraint = editConstraint.constant
        primaryTopViewConstraint = topViewConstraint.constant
        primaryShareConstraint  = shareConstraint.constant
        primaryCameraConstraint = cameraConstraint.constant
        primaryPhotoConstraint = photoConstraint.constant
    }
}



