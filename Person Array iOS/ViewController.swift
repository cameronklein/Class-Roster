//
//  ViewController.swift
//  Person Array iOS
//
//  Created by Cameron Klein on 8/7/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var personArray : [Person] = []
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initializePersonArray()
        label.text = "\(personArray.count) people loaded from Roster.plist!"
        
        for person in personArray{
            println(person.fullName())
        }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func initializePersonArray(){
        
        //Get property list
        
        let path = NSBundle.mainBundle().pathForResource("Roster", ofType:"plist")
        let dict = NSDictionary(contentsOfFile:path)
        
        var tempArray = dict["Roster"] as Array<String>
        
        for person in tempArray{
            self.personArray.append(Person(fullName: person))
        }
    }

}

