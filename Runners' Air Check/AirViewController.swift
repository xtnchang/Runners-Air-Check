//
//  AirViewController.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/13/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import UIKit

class AirViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text)
        
        let inputString = searchBar.text?.removeWhitespace()
        
        print(inputString)
        
        AirQualClient.sharedInstance.getCityAirQuality(cityName: inputString!) { (airQuality, error) in
            
            if airQuality != nil {
                
                print(airQuality)
                
                if airQuality! < 51 {
                    print("Good")
                } else if airQuality! < 100 {
                    print("Moderate")
                } else if airQuality! < 150 {
                    print("Unhealthy for sensitive groups")
                } else if airQuality! < 200 {
                    print("Unhealthy")
                } else if airQuality! < 300 {
                    print("Very unhealthy")
                } else if airQuality! >= 300 {
                    print("Hazardous")
                }
                
            } else {
                
                print("Sorry, there is currently no data for this city.")
            }
        }
        
        searchBar.text = ""
    }

}

extension String {
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
