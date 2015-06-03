//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Michael Harper on 5/24/15.
//  Copyright (c) 2015 hxx. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    //get shared memes from appdelegate
    var memes: [Meme]!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! UITableViewCell
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.imageView?.image = meme.memeImage
        
               
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("memeDetailView") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        detailController.memeIndex = indexPath.row
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    
    @IBAction func showEditor(sender: AnyObject) {
        
        let MemeEditorController = storyboard!.instantiateViewControllerWithIdentifier("EditMeme") as! MemeEditorViewController
        navigationController!.presentViewController(MemeEditorController, animated: true, completion: nil)
        
    }
    
}




