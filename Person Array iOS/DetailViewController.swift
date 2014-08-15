//
//  PersonVC.swift
//  Person Array iOS
//
//  Created by Cameron Klein on 8/11/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let USING_SIMULATOR = false
    
    var thisPerson : Person!
    
    @IBOutlet weak var personImage  :   UIImageView!
    @IBOutlet weak var nameField    :   UITextField!
    @IBOutlet weak var studentLabel :   UILabel!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        nameField.text      = thisPerson.fullName()
        studentLabel.text   = thisPerson.position
        
        if thisPerson.image != nil{
            personImage.image = thisPerson.image
        }
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEndEditing", name: "UITextFieldTextDidEndEditingNotification", object: nameField)
        self.nameField.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        if segue.identifier? == "TakePhoto" {
            
            let pickerController = segue.destinationViewController as UIImagePickerController
            
            pickerController.sourceType         =   .Camera
            pickerController.cameraCaptureMode  =   .Photo
            pickerController.cameraDevice       =   .Front
            
            pickerController.delegate           =   self
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        var nameArray = nameField.text.componentsSeparatedByString(" ")
        
        if nameArray.count < 2{
            var alert: UIAlertView = UIAlertView()
            alert.title     = "Name not updated!"
            alert.message   = "Only one name was provided. Next time, please enter both first and last name."
            alert.addButtonWithTitle("Ok")
            alert.show()
        } else {
            thisPerson.setFullName(nameField.text)
        }
    }
    
    
    @IBAction func takePhoto(sender: AnyObject) {

        if UIImagePickerController.isSourceTypeAvailable(.Camera) == USING_SIMULATOR {
            
            let myAlertView = UIAlertView(title: "Error!", message: "Device does not have camera", delegate: nil, cancelButtonTitle: "Ok")
            
            myAlertView.show()
            
        } else{
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        let image = info["UIImagePickerControllerEditedImage"] as? UIImage
        
        thisPerson.image        = image
        self.personImage.image  = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
    }


    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        println("should return")
        textField.resignFirstResponder()
        return true
    }

}