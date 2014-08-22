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
  
        let documentsDirectory = getFilePath()
        let fullPath = documentsDirectory + thisPerson.imagePath
        
        let image = UIImage(contentsOfFile: fullPath)
            
        if image != nil{
            personImage.image = image
        }

        println(fullPath)
        
        self.nameField.delegate = self
        
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
    
    override func viewWillLayoutSubviews() {
        personImage.layer.cornerRadius = self.personImage.frame.size.width / 2;
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        let image = info["UIImagePickerControllerEditedImage"] as UIImage
        
        self.personImage.image  = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let documentsDirectory = getFilePath() as String
        
        thisPerson.imagePath = "/\(thisPerson.firstName)\(thisPerson.lastName).png"
        let fullPath = documentsDirectory + thisPerson.imagePath
    
        println(fullPath)
        
        if UIImagePNGRepresentation(image).writeToFile(fullPath, atomically: true){
            println("Image Saved")
         }
        
        var writeError: NSError?
        let written = UIImagePNGRepresentation(image).writeToFile(fullPath, options: nil,
            error: &writeError)
    
        if !written {
            if let error = writeError {
                println("write failure: \(error.localizedDescription)")
            }
        }
    
        
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
    
    func getFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docDir = paths[0] as String
        return docDir
    
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            var actionSheet = UIAlertController(title: "Choose Image Source", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                picker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(picker, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(picker, animated: true, completion: nil)
            }))
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
            
        } else{
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }


    
    }
