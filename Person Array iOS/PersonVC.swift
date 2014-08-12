//
//  PersonVC.swift
//  Person Array iOS
//
//  Created by Cameron Klein on 8/11/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var studentLabel: UILabel!

    var thisPerson = Person(firstName: "John", lastName: "Doe")

    // Initializer
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    // START Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = thisPerson.fullName()
        studentLabel.text = thisPerson.position?
        if thisPerson.image != nil{
            personImage.image = thisPerson.image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // Update name of Person when pressing back button
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        var nameArray = nameField.text.componentsSeparatedByString(" ")
        if nameArray.count < 2{
            var alert: UIAlertView = UIAlertView()
            alert.title = "Name not updated!"
            alert.message = "Only one name was provided. Next time, please enter both first and last name."
            alert.addButtonWithTitle("Ok")
            alert.show()
        } else {
            thisPerson.setFullName(nameField.text)
        }
    }
    
    // END Override Functions
    
    
    
}