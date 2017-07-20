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
        
        let tabBar = self.tabBarController as! TabViewController
        savedCitiesArray = tabBar.savedCitiesArray

        print(savedCitiesArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        let tabBar = self.tabBarController as! TabViewController
//        savedCityArray = tabBar.savedCityArray
//        print(savedCityArray)
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
        
        // present AirScoreViewController with air score for the city name
    }

}
