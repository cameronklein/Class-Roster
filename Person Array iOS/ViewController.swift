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
    
    //MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveData", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    
        self.initializePersonArray()

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        personArray[0].sort { $0.firstName < $1.firstName }
        personArray[1].sort { $0.firstName < $1.firstName }
        tableView.reloadData()
        saveData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Unwind Methods
    
    @IBAction func unwindFromCreateNewPerson(segue: UIStoryboardSegue){
        
        let sourceViewController: AddPersonViewController = segue.sourceViewController as AddPersonViewController
        
        let firstName   =   sourceViewController.firstName
        let lastName    =   sourceViewController.lastName
        let position    =   sourceViewController.position as String
        let image       =   UIImage(named: " ") as UIImage
        
        if position == "Student"{
            personArray[0].append(Person(firstName: firstName!, lastName: lastName!, image: image, position: "Student"))
            println("New student \(firstName!) \(lastName!) added!")
        } else if position == "Teacher"{
            personArray[1].append(Person(firstName: firstName!, lastName: lastName!, image: image, position: "Teacher"))
            println("New teacher \(firstName!) \(lastName!) added!")
        }
    }
    
    @IBAction func unwindFromCancelButton(segue: UIStoryboardSegue){/*Do nothing*/}
    
    @IBAction func unwindFromDeletePerson(segue: UIStoryboardSegue){
    
        let sourceViewController: DetailViewController = segue.sourceViewController as DetailViewController
        
        let thisPerson : Person = sourceViewController.thisPerson
        let name = thisPerson.fullName()
        var i = 0
        
        for array in personArray{
            var j = 0
            for person in array{
                if person == thisPerson{
                    personArray[i].removeAtIndex(j)
                    println("\(name) removed from roster.")
                    break
                }
              j++
            }
            i++
        }
    
    }
    
    
    
    // MARK: UITableView Data Source / Delegate
    
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
        
//        if thisPerson.image != nil{
//            let thisImage = thisPerson.image as UIImage!
//            cell.imageView.image = thisImage
//        }
//        else{
//            cell.imageView.image = UIImage(named: "unknownSilhouette")
//        }

        
        return cell
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        switch section {
        case 0: return "Students"
        case 1: return "Teachers"
        default: return " "
            
        }
    }
    
    //MARK: Other
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
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
        if personArray.isEmpty{
            self.initializeArrayFromBackup()
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

