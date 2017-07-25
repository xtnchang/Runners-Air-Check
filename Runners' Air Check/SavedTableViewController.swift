//
//  SavedTableViewController.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/18/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import UIKit
import CoreData

class SavedTableViewController: UITableViewController {
    
    var savedCitiesArray = [String]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        // Create a fetch request to specify what objects this fetchedResultsController tracks.
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fr.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]
        
        // Specify that we only want the photos associated with the tapped pin. (pin is the relationships)
        // fr.predicate = NSPredicate(format: "city = %@", self.cityName!)
        
        // Create and return the FetchedResultsController
        return NSFetchedResultsController(fetchRequest: fr, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Where I Run"
        
        fetchedResultsController.delegate = self
 
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tabBar = self.tabBarController as! TabViewController
        savedCitiesArray = tabBar.savedCitiesArray
        tableView.reloadData()
        
        print(savedCitiesArray)
    }

    // MARK: - UITableViewDataSource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return (savedCitiesArray.count)
        
        /*** Core Data ***/
        return fetchedResultsController.sections![0].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameCell", for: indexPath)

        // cell.textLabel?.text = savedCitiesArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Avenir", size: 20)
        
        /*** Core Data ***/
        let cityToDisplay = fetchedResultsController.object(at: indexPath) as! Location
        cell.textLabel?.text = cityToDisplay.city
        
        // Do I need to save the context here?

        return cell
    }
    
    // Delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Clicked Delete")
            
            self.savedCitiesArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            
            /*** Core Data ***/
//            self.context.delete(fetchedResultsController.object(at: indexPath as IndexPath) as! Location)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            self.tableView.reloadData()
//            do {
//                try stack.context.save()
//            } catch {
//                print("Error saving the context after deleting photos")
//            }
        }
    }
 
    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Each row automatically segues to AirScoreViewController when tapped, since the segue is configured in storyboard. Pass data in prepare(for segue) method.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAirScore" {
            
            if let indexPath = tableView.indexPathForSelectedRow, let vc = segue.destination as? AirScoreViewController {
                
                vc.cityNameTapped = savedCitiesArray[indexPath.row]
            }
        }
    }

}

// MARK: - NSFetchedResultsControllerDelegate
// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html
extension SavedTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    // https://www.youtube.com/watch?v=0JJJ2WGpw_I (13:50-15:00)
    // This method is only called when anything in the context has been added or deleted. It collects the indexPaths that have changed. Then, in controllerDidChangeContent, the changes are applied to the UI.
    // The indexPath value is nil for insertions, and the newIndexPath value is nil for deletions.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    // https://www.youtube.com/watch?v=0JJJ2WGpw_I (18:15)
    // Updates the UI so that it syncs up with Core Data. This method doesn't change anything in Core Data.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
}
