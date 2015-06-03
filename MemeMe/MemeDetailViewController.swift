//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Michael Harper on 5/24/15.
//  Copyright (c) 2015 hxx. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIToolbar!
    
    var meme: Meme!
    var memeIndex: Int?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = true
        
        // changed 5/28/15
        imageView.contentMode = .ScaleAspectFit
        imageView.frame.size = meme.memeImage.size
        imageView!.image = meme.memeImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true;
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        
        if let index = memeIndex {
            let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            
            // when removing an element refer to the application delegate directly
            applicationDelegate.memes.removeAtIndex(index)
        }
        
        dismissViewControllerAnimated(true, completion: nil)

    }
    
}
