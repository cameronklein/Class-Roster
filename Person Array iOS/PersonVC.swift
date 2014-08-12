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

    var thisPerson = Person(firstName: "John", lastName: "Doe")

    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = thisPerson.fullName()
        if thisPerson.image != nil{
            personImage.image = thisPerson.image
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        thisPerson.setFullName(nameField.text)
    }
    
    
    
}