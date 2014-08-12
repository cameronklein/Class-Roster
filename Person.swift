//
//  Person.swift
//  Person Array iOS
//
//  Created by Cameron Klein on 8/6/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import Foundation
import UIKit

class Person{
    
    var firstName   : String
    var lastName    : String
    var image       : UIImage?
    
    //Initialize with seperate first and last names.
    init(firstName: String, lastName : String){
        self.firstName = firstName
        self.lastName = lastName
    }
    
    //Initialize with full name as one string.
    convenience init(fullName: String){
        var nameArray = fullName.componentsSeparatedByString(" ")
        
        self.init(firstName: nameArray[0], lastName: nameArray[1])
     
        }
    
    
    //Return full name as one string.
    func fullName() -> String {
        return self.firstName + " " + self.lastName
    }
    
    func setFullName(fullName: String){
        var nameArray = fullName.componentsSeparatedByString(" ")
        
            self.firstName = nameArray[0]
            self.lastName = nameArray[1]
        
           }
    
}