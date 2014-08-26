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
    @IBOutlet weak var cameraButton :   UIButton!
    @IBOutlet weak var gitHubUserNameField: UITextField!
    
    var imageDownloadQueue = NSOperationQueue()
    
    
    //MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        nameField.text              = thisPerson.fullName()
        studentLabel.text           = thisPerson.position
        
        let image = thisPerson.image
        
        if image != nil{
            personImage.image = UIImage(data: image)
        }
        
        if thisPerson.gitHubUserName != nil{
            gitHubUserNameField.text = thisPerson.gitHubUserName
        }
        
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.cameraButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01)
        })

        
        self.nameField.delegate = self
        
        personImage.clipsToBounds = true
        personImage.layer.borderColor = UIColor.blackColor().CGColor
        personImage.layer.borderWidth = 2
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide"), name:UIKeyboardWillHideNotification, object: nil);

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateImage()
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
        self.thisPerson.image = UIImagePNGRepresentation(image)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Keyboard Notification Methods
    
    func keyboardWillShow(){
        println("Keyboard Will Show")
    }
    
    func keyboardWillHide(){
        println("Keyboard Will Hide")
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
        
        
            
            var actionSheet = UIAlertController(title: "Choose Image Source", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                picker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(picker, animated: true, completion: nil)
            }))
        }
        
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(picker, animated: true, completion: nil)
            }))
        
            actionSheet.addAction(UIAlertAction(title: "Import from GitHub", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.askForGithubUserName()
            }))
        
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                actionSheet.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        
        }
    
    @IBAction func didTouchButton(sender: AnyObject) {
        
        cameraButton.alpha = 1.0
    }
    
    
    func animateImage(){

        UIView.animateWithDuration(1.0,
            delay: 1.0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: { () -> Void in
                self.cameraButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
            },
            completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.8,
                    delay: 1.2,
                    options: UIViewAnimationOptions.AllowUserInteraction,
                    animations: { () -> Void in
                                self.cameraButton.alpha = 0.5
                },
                    completion: nil)


            })
    }
    
    func askForGithubUserName(){
        
        var alert = UIAlertController(title: "Enter GitHub Username", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({textField in
            textField.placeholder = "Username"
            textField.secureTextEntry = false
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
            println("Confirm was tapped")
            let textField = alert.textFields[0] as UITextField
            let username = textField.text as String
            println(username)
            self.thisPerson.gitHubUserName = username
            self.updateImageFromGitHubUserName(username)
            self.gitHubUserNameField.text = username
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel , handler: {action in
            println("Cancel was tapped.")
        }))
        
        self.presentViewController(alert, animated: true, nil)
        
    }
    
    
    func updateImageFromGitHubUserName(username: String){
        
        let url = NSURL(string: "https://api.github.com/users/" + username)
        
        let request = NSURLRequest(URL: url)
    
        

    }
    
    
}
    