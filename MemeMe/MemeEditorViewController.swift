//
//  ViewController.swift
//  MemeMe
//
//  Created by Michael Harper on 4/30/15.
//  Copyright (c) 2015 hxx. All rights reserved.
// 10:15 PM

import UIKit
import Foundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var imageViewPicker: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    //MARK: Local Vars/Lets
    let picker = UIImagePickerController()
    enum TextFields  {
        case None
        case Bottom
        case Top
    }
    
    var SendingTextFieldIs = TextFields.None
    var originalImage: UIImage!
    var memedImage: UIImage!
    
    //MARK: overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self
        
        //Text field setups
        bottomTextField.text = "BOTTOM"
        //bottomTextField.textAlignment = .Center
        
        topTextField.text = "TOP"
        //topTextField.textAlignment = .Center
        
        bottomTextField.delegate = self
        topTextField.delegate = self
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(), //Fill in appropriate UIColor,
            NSForegroundColorAttributeName : UIColor.whiteColor(), //Fill in UIColor,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1
            
        ]
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.defaultTextAttributes = memeTextAttributes
        
        shareButton.enabled = false
        bottomToolBar.hidden = false
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // disable camera if in simulator
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //align textFields to center
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        tabBarController?.tabBar.hidden = true
        
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true;
    }
    
    //MARK: Member functions & Notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if SendingTextFieldIs == .Bottom {
            view.frame.origin.y -= (getKeyboardHeight(notification) - 10)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if SendingTextFieldIs == .Bottom {
            view.frame.origin.y = 0
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func noCamera() {
        let alertVC = UIAlertController( title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func save() {
        
        //Create the meme
        var meme = Meme( topText: topTextField.text, bottomText: bottomTextField.text, originalImage: originalImage, memedImage: generateMemedImage() )
        
        // Add it to the memes array in the Application Delegate
        if let object = UIApplication.sharedApplication().delegate {
            let appDelegate = object as? AppDelegate
            appDelegate?.memes.append(meme)
        } else {
            println("Save unsucessfull")
        }
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        bottomToolBar.hidden = true
        topToolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        bottomToolBar.hidden = false
        topToolBar.hidden = false
        
        return memedImage
    }
    
    
    
    //MARK: Delegates
    //what to do when the picker returns with a photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageViewPicker.contentMode = .ScaleAspectFit
        imageViewPicker.image = chosenImage
        originalImage = imageViewPicker.image
        
        //enable share button
        shareButton.enabled = true
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //what to do when the picker cancels
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // if text = TOP or BOTTOM, overrite, else append
        if textField == bottomTextField && textField.text == "BOTTOM"{
            textField.text = ""
            SendingTextFieldIs = .Bottom
            
        } else if textField == bottomTextField && textField.text != "BOTTOM"{
            SendingTextFieldIs = .Bottom
            
        } else if textField == topTextField && textField.text == "TOP"{
            textField.text = ""
            SendingTextFieldIs = .Top
            
        } else if textField == topTextField && textField.text != "TOP"{
            SendingTextFieldIs = .Top
        }
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK: Actions
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        picker.modalPresentationStyle = .Popover
        presentViewController(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    //Get a pick from the camera, make sure it exists first
    @IBAction func getFromCamera(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        var memedImage = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            
            self.save()
            controller.dismissViewControllerAnimated(true, completion: nil)
            
        }
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func CancelEditing(sender: AnyObject) {
        var sentMemeTabBarController: UITabBarController
        
        sentMemeTabBarController = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        
        presentViewController(sentMemeTabBarController, animated: true, completion: nil)
    }
}


