//
//  ComposeViewController.swift
//  Journal
//
//  Created by Duc Tran on 2/9/16.
//  Copyright © 2016 Developers Academy. All rights reserved.
//

import UIKit
//Coredata
import CoreData

class ComposeViewController: UIViewController
{
    
    //Coredata
    var managedObjectContext: NSManagedObjectContext!
    var entry: NSManagedObject!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        // Do any additional setup after loading the view.
        self.title = "Compose"
        self.textView.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = self.doneBarButtonItem
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        
        if entry != nil {
            //Theres an entry that we need to edit, passed into this class
            self.textView.text = entry.value(forKey: "bodytext") as? String
        }
        else
        {
            self.textView.text = ""
        }
        
        //createNewEntry()
    }
    
    @IBAction func doneDidClick()
    {
        //        if entry != nil {
        //            self.updateEntry()
        //        } else {
        //            if textView.text != "" {
        //                self.createNewEntry()
        //            }
        //        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func createNewEntry()
    {
        let entryEntity = NSEntityDescription.entity(forEntityName: "Entry", in: self.managedObjectContext)!
        let entryObject = NSManagedObject(entity: entryEntity, insertInto: self.managedObjectContext)
        entryObject.setValue(self.textView.text, forKey: "bodytext")
        entryObject.setValue(Date(), forKey: "createdAt")
        
        do {
            try managedObjectContext.save()
        }   catch let error as NSError {
            print("Deu pau \(error.description)")
        }
    }
    
    func updateEntry()
    {
        entry.setValue(self.textView.text, forKey: "bodytext")
        entry.setValue(Date(), forKey: "createdAt")
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print ("could not save \(error)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if entry != nil {
            self.updateEntry()
        } else {
            if textView.text != "" {
                self.createNewEntry()
            }
        }
    }
    
    func appMovedToBackground() {
        salvarRegistro()
    }

    
    func salvarRegistro() {
        if entry != nil {
            self.updateEntry()
        } else {
            if textView.text != "" {
                self.createNewEntry()
            }
        }

    }
}

























