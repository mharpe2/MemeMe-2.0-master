//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Michael Harper on 5/11/15.
//  Copyright (c) 2015 hxx. All rights reserved.
//

import UIKit

class MemeCollectionViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("colCell", forIndexPath: indexPath) as! MemeCollectionCell
        let meme = memes[indexPath.row]
        
        // Setup cell
        cell.memedImage.contentMode = .ScaleAspectFit
        cell.memedImage.image = meme.memeImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
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
