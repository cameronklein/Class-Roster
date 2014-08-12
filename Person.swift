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
    var position    : String?
    
    //Initialize with seperate first and last names.
    init( firstName: String, lastName : String){
        self.firstName = firstName
        self.lastName = lastName
    }
    
    //Initialize with full name as one string.
    convenience init(fullName: String){
        var nameArray = fullName.componentsSeparatedByString(" ")
        
        
        //Handle long names
        if nameArray.count == 2{
            self.init(firstName: nameArray[0], lastName: nameArray.last as String!)
        } else{
            var first = nameArray[0]
            for i in 1..<(nameArray.count-1) {
                first = first + " " + nameArray[i]
                }
            self.init(firstName: first, lastName: nameArray.last as String!)
        }
        
        
     
    }
    
    convenience init(firstName: String, lastName: String, image: UIImage, position: String){
        self.init(firstName: firstName, lastName: lastName)
        self.image = image
        self.position = position
    }
    
    
    //Return full name as one string.
    func fullName() -> String {
        return self.firstName + " " + self.lastName
    }
    
    func setFullName(fullName: String){
        var nameArray = fullName.componentsSeparatedByString(" ")
        
        //Handle long names
        if nameArray.count == 2{
            self.firstName = nameArray[0]
            self.lastName = nameArray.last as String!
        } else{
            var first = nameArray[0]
            for i in 1..<(nameArray.count-1) {
                first = first + " " + nameArray[i]
            }
            self.firstName = first
            self.lastName = nameArray.last as String!
        }

        
           }
    
}