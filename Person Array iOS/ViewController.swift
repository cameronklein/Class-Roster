//
//  ViewController.swift
//  Person Array iOS
//
//  Created by Cameron Klein on 8/7/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
  
    @IBOutlet weak var tableView: UITableView!
    var personArray = [[Person]]()

    //MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializePersonArray()

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.initializePersonArray()
        personArray[0].sort { $0.firstName < $1.firstName }
        personArray[1].sort { $0.firstName < $1.firstName }
        tableView.reloadData()
        
        saveData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Unwind Methods
    
    @IBAction func unwindFromCreateNewPerson(segue: UIStoryboardSegue){
        
        let sourceViewController: AddPersonViewController = segue.sourceViewController as AddPersonViewController
        
        let firstName   =   sourceViewController.firstName
        let lastName    =   sourceViewController.lastName
        let position    =   sourceViewController.position as String
        let imagePath       =   " "
        
        var appDel : AppDelegate =  UIApplication.sharedApplication().delegate as AppDelegate
        var context  : NSManagedObjectContext =  appDel.managedObjectContext!
        
        var newPerson = NSEntityDescription.insertNewObjectForEntityForName("People", inManagedObjectContext: context) as Person
        
        newPerson.firstName     = firstName!
        newPerson.lastName      = lastName!
        newPerson.imagePath     = imagePath
        newPerson.position      = position

        context.save(nil)
        initializePersonArray() 
        
        println(newPerson.fullName())
        
    }
    
    @IBAction func unwindFromCancelButton(segue: UIStoryboardSegue){/*Do nothing*/}
    
    
    @IBAction func unwindFromDeletePerson(segue: UIStoryboardSegue){
    
        let sourceViewController: DetailViewController = segue.sourceViewController as DetailViewController
        
        let thisPerson : Person = sourceViewController.thisPerson
        
        var appDel   : AppDelegate =  UIApplication.sharedApplication().delegate as AppDelegate
        var context  : NSManagedObjectContext =  appDel.managedObjectContext!
        
        context.deleteObject(thisPerson)
    
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
        var thisPerson = self.personArray[indexPath.section][indexPath.row] as Person
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
    
    func initializePersonArray(){
        
        var appDel : AppDelegate =  UIApplication.sharedApplication().delegate as AppDelegate
        var context  : NSManagedObjectContext =  appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "People")
        request.returnsObjectsAsFaults = false
        
        personArray.removeAll(keepCapacity: true)
        
        request.predicate = NSPredicate(format: "position == %@", "Student")
        var studentArray = context.executeFetchRequest(request, error: nil) as [Person]
        if studentArray.isEmpty == false{
            personArray.append(studentArray)
        }
        
        request.predicate = NSPredicate(format: "position == %@", "Teacher")
        var teacherArray = context.executeFetchRequest(request, error: nil) as [Person]
        if teacherArray.isEmpty == false{
            personArray.append(teacherArray)
        }
        
        if personArray.isEmpty{
            self.initializeArrayFromBackup()
        }
        
    }
    
    func saveData(){

        var appDel : AppDelegate =  UIApplication.sharedApplication().delegate as AppDelegate
        var context  : NSManagedObjectContext =  appDel.managedObjectContext!
        
        if context.save(nil){
            println("Data Successfully Saved")
        }
    }
    
    func initializeArrayFromBackup(){
        
        let path = NSBundle.mainBundle().pathForResource("Roster", ofType:"plist")
        let array = NSArray(contentsOfFile:path!)
        
        var teacherArray = [Person]()
        var studentArray = [Person]()
        
        var appDel   : AppDelegate =  UIApplication.sharedApplication().delegate as AppDelegate
        var context  : NSManagedObjectContext =  appDel.managedObjectContext!
        
        
        for person in array{
        
            var thisPerson: AnyObject! = NSEntityDescription.insertNewObjectForEntityForName("People", inManagedObjectContext: context)
            
            thisPerson.setValue(person["firstName"] , forKey: "firstName")
            thisPerson.setValue(person["lastName"]  , forKey: "lastName")
            thisPerson.setValue(person["position"]  , forKey: "position")
            thisPerson.setValue(person["image"]     , forKey: "imagePath")
            thisPerson.setValue(nil                 , forKey: "image")
            
            context.save(nil)
            println(thisPerson)
            
        }
    }




}

