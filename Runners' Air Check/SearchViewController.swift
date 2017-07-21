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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        activityIndicator.hidesWhenStopped = true
        searchBar.delegate = self
        airScoreCircle.isHidden = true
        cityLabel.numberOfLines = 0 // Allows multi-line
        messageLabel.numberOfLines = 0
        trailImageView.isHidden = true
        treadmillImageView.isHidden = true
        dogImageView.isHidden = true
        saveButton.isHidden = true
        messageLabel.text = "Where will you run today?"
        
        // When user taps anywhere in the UIView, dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        print("Save button pressed for \(self.cityName)")
        
        let tabBar = self.tabBarController as! TabViewController
        tabBar.savedCitiesArray.append(self.cityName!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text ?? "")
        
        self.cityName = searchBar.text
        
        let cityNameConcatenate = searchBar.text?.removeWhitespace()
        
        print(cityNameConcatenate ?? "")
        
        activityIndicator.startAnimating()
        
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
                    print("Good: green.")
                    
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
                        self.airScoreCircle.color = UIColor(red: 0.6824, green: 1, blue: 0.4863, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                        self.saveButton.layer.borderWidth = 1
                        self.saveButton.layer.borderColor = UIColor.white.cgColor
                    }
                } else if airQuality! < 100 {
                    print("Moderate: yellow")
                    
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
                        self.airScoreCircle.color = UIColor(red: 1, green: 0.9647, blue: 0.4863, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! < 150 {
                    print("Unhealthy for sensitive groups: orange")
                    
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
                        self.airScoreCircle.color = UIColor(red: 1, green: 0.7843, blue: 0.4863, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! < 200 {
                    print("Unhealthy: red")
                    
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
                        self.airScoreCircle.color = UIColor(red: 0.9569, green: 0.4667, blue: 0.4667, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! < 300 {
                    print("Very unhealthy: purple")
                    
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
                        self.airScoreCircle.color = UIColor(red: 0.651, green: 0.5059, blue: 0.7569, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! >= 300 {
                    print("Hazardous: brown")
                    
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
                        self.airScoreCircle.color = UIColor(red: 0.6196, green: 0.5333, blue: 0.4118, alpha: 1.0)
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
        searchBar.endEditing(true)
        activityIndicator.stopAnimating()
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
