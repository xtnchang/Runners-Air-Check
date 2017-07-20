//
//  SavedTableViewController.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/18/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import UIKit

class SavedTableViewController: UITableViewController {
    
    var savedCitiesArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Where I Run"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tabBar = self.tabBarController as! TabViewController
        savedCitiesArray = tabBar.savedCitiesArray
        tableView.reloadData()
        
        print(savedCitiesArray)
    }

    // MARK: - UITableViewDataSource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (savedCitiesArray.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameCell", for: indexPath)

        cell.textLabel?.text = savedCitiesArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Avenir", size: 20)

        return cell
    }
    
    // Delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Clicked Delete")
            
            self.savedCitiesArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
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
