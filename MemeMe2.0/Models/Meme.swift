
//
//  MemeObject.swift
//  MemeMe2.0
//
//  Created by Lucas César  Nogueira Fonseca on 04/05/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import UIKit

class Meme: NSObject, NSCoding {
    
    //MARK: Properties
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memeImage: UIImage
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("memes")
    
    //MARK: Types
    
    struct PropertyKey {
        static let topText = "topText"
        static let bottomText = "bottomText"
        static let originalImage = "originalImage"
        static let memeImage = "memeImage"
    }
    
     //MARK: Initialization
    init?(topText: String,bottomText: String, originalImage: UIImage, memeImage: UIImage) {
        // Initialize stored properties.
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(topText, forKey: PropertyKey.topText)
        aCoder.encode(bottomText, forKey: PropertyKey.bottomText)
        aCoder.encode(originalImage, forKey: PropertyKey.originalImage)
        aCoder.encode(memeImage, forKey: PropertyKey.memeImage)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let topText = aDecoder.decodeObject(forKey: PropertyKey.topText) as! String
        let bottomText = aDecoder.decodeObject(forKey: PropertyKey.bottomText) as! String
        let originalImage = aDecoder.decodeObject(forKey: PropertyKey.originalImage) as! UIImage
        let memeImage = aDecoder.decodeObject(forKey: PropertyKey.memeImage) as! UIImage
        
        self.init(topText: topText, bottomText: bottomText, originalImage: originalImage, memeImage: memeImage)
    }
}
