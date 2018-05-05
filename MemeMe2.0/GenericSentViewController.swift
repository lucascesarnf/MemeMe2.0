//
//  GenericSentViewController.swift
//  MemeMe2.0
//
//  Created by Lucas César  Nogueira Fonseca on 05/05/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit

extension UIViewController {
    func empityLabel() -> UILabel {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = "You don't have any meme yet.\nYou can create and share \nselecting the plus on the top of the screen."
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        return messageLabel
    }
}
