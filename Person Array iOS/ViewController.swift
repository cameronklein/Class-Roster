//
//  ViewController.swift
//  Person Array iOS
//
//  Created by Cameron Klein on 8/7/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
  
    @IBOutlet weak var tableView: UITableView!
    var personArray = [[Person]]()
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveData", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    
        self.initializePersonArray()
        
        for array in personArray{
            for person in array{
                println(person.fullName())
            }
        }
        
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        personArray[0].sort { $0.firstName < $1.firstName }
        personArray[1].sort { $0.firstName < $1.firstName }
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        // Seque to detail view -- pass person to destination view controller
        
        if segue.identifier! == "Detail" {
            let index = tableView.indexPathForSelectedRow()
            let selectedPerson = personArray[index.section][index.row]
            let destination = segue.destinationViewController as DetailViewController
            destination.thisPerson = selectedPerson
        }
    }
    
    
    func getFilePathOfData() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let dir = paths[0] as String
        let fullPath = dir + "/People"
        
        return fullPath
    }
    
    
    func initializePersonArray(){
        
        personArray = NSKeyedUnarchiver.unarchiveObjectWithFile(self.getFilePathOfData()) as [[Person]]
        
        // Uncomment below to load from Roster.plist in case of corrupted backup file
        // initializeArrayFromBackup()
        
    }
    
 

    
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        
        return personArray.count
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
       return personArray[section].count
        
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell = tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var thisPerson = self.personArray[indexPath.section][indexPath.row]
        cell.textLabel.text = thisPerson.fullName()
        return cell
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        switch section {
        case 0: return "Students"
        case 1: return "Teachers"
        default: return " "
        
        }
    }
    

    
    func saveData(){
        
        let newPersonArray = personArray as NSArray
        let filePath = self.getFilePathOfData()
        var success = NSKeyedArchiver.archiveRootObject(newPersonArray, toFile: filePath)
        if success{
            println("Data Successfully Saved")
        }
    }
    
    
    @IBAction func unwindFromCreateNewPerson(segue: UIStoryboardSegue){
        
        let sourceViewController: AddPersonViewController = segue.sourceViewController as AddPersonViewController
        
        let firstName   =   sourceViewController.firstName
        let lastName    =   sourceViewController.lastName
        let position    =   sourceViewController.position as String
        let image       =   UIImage(named: " ") as UIImage
        
        if position == "Student"{
            personArray[0].append(Person(firstName: firstName!, lastName: lastName!, image: image, position: "Student"))
            println("New Student Added!")
        }
        else if position == "Teacher"{
            personArray[1].append(Person(firstName: firstName!, lastName: lastName!, image: image, position: "Teacher"))
            println("New Teacher Added!")
        }
    }
    
    @IBAction func unwindFromCancelButton(segue: UIStoryboardSegue){/*Do nothing*/}
    
    @IBAction func unwindFromDeletePerson(segue: UIStoryboardSegue){
    
        let sourceViewController: DetailViewController = segue.sourceViewController as DetailViewController
        
        let thisPerson : Person = sourceViewController.thisPerson
        var i = 0
        var j = 0
        for array in personArray{
            for person in array{
                if person == thisPerson{
                    personArray[i].removeAtIndex(j)
                    println("Searched")
                }
              j++
            }
            i++
        }
    
    }
    
    
    func initializeArrayFromBackup(){

        let path = NSBundle.mainBundle().pathForResource("Roster", ofType:"plist")
        let array = NSArray(contentsOfFile:path)

        var teacherArray = [Person]()
        var studentArray = [Person]()

        for person in array{

            var thisFirst = person["firstName"] as String
            var thisLast = person["lastName"] as String
            var imagePath = person["image"] as String
            var thisImage = UIImage(named: imagePath) as UIImage
            var thisPosition = person["position"] as String
            var thisPerson = Person(firstName: thisFirst, lastName: thisLast, image: thisImage, position: thisPosition)
            if thisPosition == "Teacher"{
                teacherArray.append(thisPerson)
            } else if thisPosition == "Student"{
                studentArray.append(thisPerson)
            }

        }
        studentArray.sort { $0.firstName < $1.firstName }
        teacherArray.sort { $0.firstName < $1.firstName }
        self.personArray.append(studentArray)
        self.personArray.append(teacherArray)
        
        
    }


}

