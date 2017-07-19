//
//  SearchViewController.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/13/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var fullScreenView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var airScoreLabel: UILabel!
    @IBOutlet weak var airScoreCircle: AirScoreView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var trailImageView: UIImageView!
    @IBOutlet weak var treadmillImageView: UIImageView!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var cityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        self.airScoreCircle.isHidden = true
        cityLabel.numberOfLines = 0 // Allows multi-line
        messageLabel.numberOfLines = 0
        trailImageView.isHidden = true
        treadmillImageView.isHidden = true
        dogImageView.isHidden = true
        saveButton.isHidden = true
        messageLabel.text = "Where will you run today?"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        return
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        // Somehow append the city name to the savedCityArray in table view controller
        
        // SavedTableViewController.sharedInstance.savedCityArray.append(self.cityName)
        
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SavedTableViewController") as! SavedTableViewController
//        controller.savedCityArray.append(self.cityName)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text ?? "")
        
        self.cityName = searchBar.text
        
        let cityNameConcatenate = searchBar.text?.removeWhitespace()
        
        print(cityNameConcatenate ?? "")
        
        AirQualClient.sharedInstance.getCityAirQuality(inputString: self.cityName!, inputStringConcatenate: cityNameConcatenate!) { (airQuality, error) in
            
            guard (error == nil) else {
                DispatchQueue.main.async {
                    self.airScoreCircle.isHidden = true
                    self.cityLabel.isHidden = true
                    self.saveButton.isHidden = true
                    self.dogImageView.isHidden = false
                    self.messageLabel.text = "\(error!.localizedDescription)"
                }
                return
            }
            
            if airQuality != nil {
                
                print(airQuality ?? "")
                
                if airQuality! < 51 {
                    print("Good")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityName
                        self.messageLabel.text = "The air’s great! \nGo run your socks off!!"
                        self.dogImageView.isHidden = true
                        self.treadmillImageView.isHidden = true
                        self.trailImageView.isHidden = false
                        self.saveButton.isHidden = false
                        self.airScoreCircle.color = UIColor.green
                        self.airScoreCircle.setNeedsDisplay()
                        self.saveButton.layer.borderWidth = 1
                        self.saveButton.layer.borderColor = UIColor.white.cgColor
                    }
                } else if airQuality! < 100 {
                    print("Moderate")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityName
                        self.messageLabel.text = "The air’s pretty good. \nGet in those miles!"
                        self.dogImageView.isHidden = true
                        self.treadmillImageView.isHidden = true
                        self.trailImageView.isHidden = false
                        self.saveButton.isHidden = false
                        self.airScoreCircle.color = UIColor.yellow
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! < 150 {
                    print("Unhealthy for sensitive groups")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityName
                        self.messageLabel.text = "The air’s okay. Take it easy out there, especially if you have asthma!"
                        self.dogImageView.isHidden = true
                        self.treadmillImageView.isHidden = true
                        self.trailImageView.isHidden = false
                        self.saveButton.isHidden = false
                        self.airScoreCircle.color = UIColor.orange
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! < 200 {
                    print("Unhealthy")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityName
                        self.messageLabel.text = "The air’s not great. Better stick to the treadmill!"
                        self.dogImageView.isHidden = true
                        self.trailImageView.isHidden = true
                        self.treadmillImageView.isHidden = false
                        self.saveButton.isHidden = false
                        self.airScoreCircle.color = UIColor.red
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! < 300 {
                    print("Very unhealthy")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityName
                        self.messageLabel.text = "The air’s pretty polluted. Better stick to the treadmill, and avoid going out!"
                        self.dogImageView.isHidden = true
                        self.trailImageView.isHidden = true
                        self.treadmillImageView.isHidden = false
                        self.saveButton.isHidden = false
                        self.airScoreCircle.color = UIColor.purple
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! >= 300 {
                    print("Hazardous")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityName
                        self.messageLabel.text = "The air is dangerously polluted. Better stick to the treadmill, and keep your windows shut!"
                        self.dogImageView.isHidden = true
                        self.trailImageView.isHidden = true
                        self.treadmillImageView.isHidden = false
                        self.saveButton.isHidden = false
                        self.airScoreCircle.color = UIColor.brown
                        self.airScoreCircle.setNeedsDisplay()
                    }
                }
                
            } else {
                
                DispatchQueue.main.async {
                    self.airScoreCircle.isHidden = true
                    self.cityLabel.isHidden = true
                    self.dogImageView.isHidden = false
                    self.messageLabel.text = "Sorry, there is currently no data for \(self.cityName!). Go for a run anyway!"
                }

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
