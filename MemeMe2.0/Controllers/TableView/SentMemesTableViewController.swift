//
//  SentMemesTableViewController.swift
//  MemeMe2.0
//
//  Created by Lucas César  Nogueira Fonseca on 04/05/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMemes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMemes()
    }
    
    func updateMemes() {
        memes = MemeList.sharedInstance.getMemes()
        tableView.reloadData()
    }
    
    // MARK: - Empty Table View
    private func EmptyMessage(shouldShow: Bool) {
        
        if shouldShow {
            
            let messageLabel = empityLabel()
            
            self.tableView.backgroundView = messageLabel
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
    }
    
    
    //Here we control the Empty Message exhibition
    override func numberOfSections(in tableView: UITableView) -> Int {
        if memes.count > 0 {
             EmptyMessage(shouldShow: false)
            return 1
        } else {
            EmptyMessage(shouldShow: true)
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        let meme:Meme = memes[indexPath.row]
        cell.memeImage.image = meme.properties.memeImage
        cell.memeTopText.text = meme.properties.topText
        cell.memeBottomText.text = meme.properties.bottomText
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MemeList.sharedInstance.removeMeme(at: indexPath.row)
            updateMemes()
        }
    }

}
