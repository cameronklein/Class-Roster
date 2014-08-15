//
//  AddPersonViewController.swift
//  Person Array iOS
//
//  Created by Cameron Klein on 8/14/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class AddPersonViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var firstName : String?
    var lastName : String?
    var position : String = "Student"
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var positionPicker: UIPickerView!
    
    //START Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.positionPicker.dataSource = self
        self.positionPicker.delegate = self
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        firstName = firstNameField.text
        lastName = lastNameField.text
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        
        switch row{
            case 0: return "Student"
            case 1: return "Teacher"
            default: return ""
        }
    }
    
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        if row == 0{
            position = "Student"
        }
        if row == 1{
            position = "Teacher"
        }
    }
    
}