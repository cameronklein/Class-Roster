//
//  PersonVC.swift
//  Person Array iOS
//
//  Created by Cameron Klein on 8/11/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var thisPerson : Person!
    
    @IBOutlet weak var personImage  :   UIImageView!
    @IBOutlet weak var nameField    :   UITextField!
    @IBOutlet weak var studentLabel :   UILabel!

    //MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        nameField.text      = thisPerson.fullName()
        studentLabel.text   = thisPerson.position
        
        if thisPerson.image != nil{
            personImage.image = thisPerson.image
        }
        
        
        self.nameField.delegate = self
        
        personImage.layer.cornerRadius = self.personImage.frame.size.width / 2;
        personImage.clipsToBounds = true
        personImage.layer.borderColor = UIColor.blackColor().CGColor
        personImage.layer.borderWidth = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        let image = info["UIImagePickerControllerEditedImage"] as UIImage
        
        thisPerson.image        = image
        self.personImage.image  = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        println("should return")
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Other
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        nameField.resignFirstResponder()
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) == false{
            let myAlertView = UIAlertView(title: "Error!", message: "Device does not have camera -- using photo picker instead.", delegate: nil, cancelButtonTitle: "Ok")
            myAlertView.show()
        } else{
            picker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        self.presentViewController(picker, animated: true, completion: nil)
    }

}