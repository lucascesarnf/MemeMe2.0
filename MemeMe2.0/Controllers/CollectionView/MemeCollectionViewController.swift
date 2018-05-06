//
//  MemeCollectionViewController.swift
//  MemeMe2.0
//
//  Created by Lucas César  Nogueira Fonseca on 04/05/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var memes: [Meme]!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMemes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let space:CGFloat = 3.0
        //let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let widthDimension = (view.frame.size.width - (10 * space)) / 3.0
        let heightDimension = (view.frame.size.height - (4 * space)) / 4.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        //flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
        updateMemes()
    }
    
    func updateMemes() {
        memes = MemeList.sharedInstance.getMemes()
        collectionView?.reloadData()
    }
    
    // MARK: - Empty Table View
    private func EmptyMessage(shouldShow: Bool) {
        
        if shouldShow {
            
            let messageLabel = empityLabel()
            
            self.collectionView?.backgroundView = messageLabel
        } else {
            self.collectionView?.backgroundView = nil
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if memes.count > 0 {
            EmptyMessage(shouldShow: false)
            return 1
        } else {
            EmptyMessage(shouldShow: true)
            return 0
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        // Set the image
        cell.memeImageView.image = meme.properties.memeImage
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
