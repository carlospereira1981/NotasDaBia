//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Duc Tran on 2/9/16.
//  Copyright © 2016 Developers Academy. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController
    
//    , UISearchResultsUpdating
{
    
    var managedObjectContext: NSManagedObjectContext!
    var entries : [NSManagedObject]!
    
    //Codigo para fazer a pesquisa
    //var filteredItens = [String]()
    //var resultSearchController = UISearchController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //codigo para fazer a pesquisa
//        self.resultSearchController = UISearchController(searchResultsController: nil)
//        self.resultSearchController.searchResultsUpdater = self
//        
//        self.resultSearchController.dimsBackgroundDuringPresentation = false
//        self.resultSearchController.searchBar.sizeToFit()
//        self.tableView.tableHeaderView = self.resultSearchController.searchBar
//        self.tableView.reloadData()
        
        self.title = "Bloco de Notas da Bia"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        // esse cara limpa as celulas vazias da uiview
        tableView.tableFooterView = UIView()
        fetchEntries()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        fetchEntries()       
        super.viewWillAppear(animated)
    }
    
    func fetchEntries()
    {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Entry")
        //let fecthRequest = NSFetchRequest(entityName: "Entry")
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let entryObjects = try managedObjectContext.fetch(fetchRequest)
            self.entries = entryObjects as! [NSManagedObject]
        } catch let error as NSError {
            print("erro \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Target action
    
    @IBAction func composeDidClick(_ sender: AnyObject)
    {
        self.performSegue(withIdentifier: "Show Composer", sender: nil)
    }

    // MARK: - UITableViewDatasource
    
    // 11 Populate entries into table view

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if self.resultSearchController.active
//        {
//            return self.filteredItens.count
//        }
//        else
//        {
              if self.entries != nil
            {
                return self.entries.count
            } else {
                return 1
            }
//        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Entry Cell", for: indexPath)
        
//        if self.resultSearchController.active
//        {
//            cell.textLabel?.text = self.filteredItens[indexPath.row]
//        }
//        else
//        {
            if self.entries != nil
            {
                let entry = self.entries[(indexPath as NSIndexPath).row]
                cell.textLabel?.text = entry.value(forKey: "bodytext") as? String
                let entryDate = entry.value(forKey: "createdAt") as! Date
//              cell.detailTextLabel?.text = dateTimeFormattedAsTimeAgo(entryDate)
                let formatter = DateFormatter()
                formatter .dateStyle = DateFormatter.Style.medium
                cell.detailTextLabel?.text = formatter.string(from: entryDate)
            }
        return cell
//        }
//        return cell
    }

//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        //self.filteredItens.removeAll(keepCapacity: false)
//        
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
//        let array = (self.entries as NSArray).filteredArrayUsingPredicate(searchPredicate)
//        self.filteredItens = array as! [String]
//        self.tableView.reloadData()
//    }
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let entry = self.entries[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "Show Composer", sender: entry)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = self.entries[(indexPath as NSIndexPath).row]
            self.managedObjectContext.delete(entry)
            self.entries.remove(at: (indexPath as NSIndexPath).row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                print("nao consigo deletar \(error)")
            }
            
        }
        
    }

    // 13 - give the compose vc its entry
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "Show Composer" {
            let composeViewController = segue.destination as! ComposeViewController
            composeViewController.entry = sender as? NSManagedObject
        }
    }
}



























