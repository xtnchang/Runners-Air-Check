//
//  SearchViewController.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/13/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//  test comment

import UIKit
import CoreData

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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        /*** Core Data ***/
        let savedLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context)
        
        savedLocation.setValue(self.cityName, forKey: "city")
        
        appDelegate.saveContext()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text ?? "")
        
        cityName = searchBar.text
        
        let cityNameConcatenate = searchBar.text?.removeWhitespace()
        
        print(cityNameConcatenate ?? "")
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        AirQualClient.sharedInstance.getCityAirQuality(inputString: self.cityName!, inputStringConcatenate: cityNameConcatenate!) { (airQuality, error) in
            
            guard (error == nil) else {
                DispatchQueue.main.async {
                    self.airScoreCircle.isHidden = true
                    self.cityLabel.isHidden = true
                    self.saveButton.isHidden = true
                    self.dogImageView.isHidden = false
                    self.messageLabel.text = "\(error!.localizedDescription)"
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard (airQuality != nil) else {
                DispatchQueue.main.async {
                    self.airScoreCircle.isHidden = true
                    self.cityLabel.isHidden = true
                    self.saveButton.isHidden = true
                    self.dogImageView.isHidden = false
                    self.messageLabel.text = "Sorry, there is currently no data for \(self.cityName!). Go for a run anyway!"
                    self.activityIndicator.stopAnimating()
                }
                return
            }
                
            switch airQuality {
                
                case _ where airQuality! < 51:
                
                    print("Good: green.")
                    
                    DispatchQueue.main.async {
                    
                    self.loadUI(airQuality: airQuality!, messageText: "The air’s great! \nGo run your socks off!!")
                    self.trailImageView.isHidden = false
                    self.airScoreCircle.color = UIColor(red: 0.6824, green: 1, blue: 0.4863, alpha: 1.0)
                    self.airScoreCircle.setNeedsDisplay()
                }
                
                case _ where airQuality! >= 51 && airQuality! < 100:
                
                    print("Moderate: yellow")
                    
                    DispatchQueue.main.async {
                    
                    self.loadUI(airQuality: airQuality!, messageText: "The air’s pretty good. \nGet in those miles!")
                    self.trailImageView.isHidden = false
                    self.airScoreCircle.color = UIColor(red: 1, green: 0.9647, blue: 0.4863, alpha: 1.0)
                    self.airScoreCircle.setNeedsDisplay()
                }
                
                case _ where airQuality! >= 100 && airQuality! < 150:
                
                    print("Unhealthy for sensitive groups: orange")
                    
                    DispatchQueue.main.async {
                    
                    self.loadUI(airQuality: airQuality!, messageText: "The air’s okay. Take it easy out there, especially if you have asthma!")
                    self.trailImageView.isHidden = false
                    self.airScoreCircle.color = UIColor(red: 1, green: 0.7843, blue: 0.4863, alpha: 1.0)
                    self.airScoreCircle.setNeedsDisplay()
                }
                
                case _ where airQuality! >= 150 && airQuality! < 200:
                
                    print("Unhealthy: red")
                    
                    DispatchQueue.main.async {
                    
                    self.loadUI(airQuality: airQuality!, messageText: "The air’s not great. Better stick to the treadmill!")
                    self.treadmillImageView.isHidden = false
                    self.airScoreCircle.color = UIColor(red: 0.9569, green: 0.4667, blue: 0.4667, alpha: 1.0)
                    self.airScoreCircle.setNeedsDisplay()
                }
                
                case _ where airQuality! >= 200 && airQuality! < 300:
                
                    print("Very unhealthy: purple")
                    
                    DispatchQueue.main.async {
                    
                    self.loadUI(airQuality: airQuality!, messageText: "The air’s pretty polluted. Better stick to the treadmill, and avoid going out!")
                    self.treadmillImageView.isHidden = false
                    self.airScoreCircle.color = UIColor(red: 0.651, green: 0.5059, blue: 0.7569, alpha: 1.0)
                    self.airScoreCircle.setNeedsDisplay()
                }
                
                case _ where airQuality! >= 300:
                
                    print("Hazardous: brown")
                    
                    DispatchQueue.main.async {
                    
                    self.loadUI(airQuality: airQuality!, messageText: "The air is dangerously polluted. Better stick to the treadmill, and keep your windows shut!")
                    self.treadmillImageView.isHidden = false
                    self.airScoreCircle.color = UIColor(red: 0.6196, green: 0.5333, blue: 0.4118, alpha: 1.0)
                    self.airScoreCircle.setNeedsDisplay()
                }
                
                default:
                print("Impossible")
            }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    func loadUI(airQuality: Int, messageText: String) {
        airScoreCircle.isHidden = false
        airScoreLabel.text = String(describing: airQuality)
        messageLabel.text = messageText
        cityLabel.isHidden = false
        cityLabel.text = cityName
        dogImageView.isHidden = true
        treadmillImageView.isHidden = true
        trailImageView.isHidden = true
        saveButton.isHidden = false
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.white.cgColor
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
