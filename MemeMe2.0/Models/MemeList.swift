//
//  MemeList.swift
//  MemeMe2.0
//
//  Created by Lucas César  Nogueira Fonseca on 04/05/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import UIKit

//Clas to control the meme list
final class MemeList: NSObject {
    
    //List of memes
    private var memes = [Meme]()
    
    //Singleton Instance class
    static let sharedInstance = MemeList()
    
    //Load memeFrom local persistence
    private override init() {
        super.init()
        
        if let loadMemes = loadMemes() {
            memes = loadMemes
        }
    }
    
    //Save memes localy
    private func persistMemes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(memes, toFile: Meme.ArchiveURL.path)
        if isSuccessfulSave {
            print("meme saved successfully")
        } else {
            print("Failed to save memes...")
        }
    }
    
    //Get memes from local persistence
    private func loadMemes() -> [Meme]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meme.ArchiveURL.path) as? [Meme]
    }
    
    //Get memes to list
    func getMemes() -> [Meme] {
        return memes
    }
    
    //Add new meme
    func addMeme(meme: Meme) {
        memes.append(meme)
        persistMemes()
    }
    
    func removeMeme(at: Int) {
        memes.remove(at: at)
        persistMemes()
    }
}
