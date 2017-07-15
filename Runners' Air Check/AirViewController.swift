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
    @IBOutlet weak var airScoreLabel: UILabel!
    @IBOutlet weak var airScoreCircle: AirScoreView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var cityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  
        searchBar.delegate = self
        airScoreCircle.color = UIColor.gray
        messageLabel.numberOfLines = 0 // Allows multi-line
    }
    
    override func viewWillAppear(_ animated: Bool) {
        return
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text ?? "")
        
        self.cityName = searchBar.text
        
        let inputString = searchBar.text?.removeWhitespace()
        
        print(inputString ?? "")
        
        AirQualClient.sharedInstance.getCityAirQuality(cityName: inputString!) { (airQuality, error) in
            
            if airQuality != nil {
                
                print(airQuality ?? "")
                
                if airQuality! < 51 {
                    print("Good")
                    
                    DispatchQueue.main.async {
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.text = self.cityName
                        self.messageLabel.text = "The air’s great! \nGo run your socks off!!"
                        self.airScoreCircle.color = UIColor.green
                    }
                } else if airQuality! < 100 {
                    print("Moderate")
                    
                    DispatchQueue.main.async {
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.text = self.cityName
                        self.messageLabel.text = "The air’s pretty good. \nGet in those miles!"
                        self.airScoreCircle.color = UIColor.yellow
                    }
                } else if airQuality! < 150 {
                    print("Unhealthy for sensitive groups")
                    
                    DispatchQueue.main.async {
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.messageLabel.text = "The air’s okay. Take it easy out there, especially if you have asthma!"
                        self.airScoreCircle.color = UIColor.orange
                    }
                } else if airQuality! < 200 {
                    print("Unhealthy")
                    
                    DispatchQueue.main.async {
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.messageLabel.text = "The air’s not great. Better stick to the treadmill!"
                        self.airScoreCircle.color = UIColor.red
                    }
                } else if airQuality! < 300 {
                    print("Very unhealthy")
                    
                    DispatchQueue.main.async {
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.messageLabel.text = "The air’s pretty polluted. Better stick to the treadmill, and avoid going out!"
                        self.airScoreCircle.color = UIColor.purple
                    }
                } else if airQuality! >= 300 {
                    print("Hazardous")
                    
                    DispatchQueue.main.async {
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.messageLabel.text = "The air is dangerously polluted. Better stick to the treadmill, and keep your windows shut!"
                        self.airScoreCircle.color = UIColor.brown
                    }
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
