//
//  MemeDetailsViewController.swift
//  MemeMe2.0
//
//  Created by Lucas César  Nogueira Fonseca on 04/05/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTopLabel: UILabel!
    @IBOutlet weak var memeBottomLabel: UILabel!

    
    var meme:Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meme = meme {
            memeImageView.image = meme.memeImage
            memeTopLabel.text = meme.topText
            memeBottomLabel.text = meme.bottomText
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
