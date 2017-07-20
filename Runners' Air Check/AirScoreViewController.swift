//
//  AirScoreViewController.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/18/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import UIKit

class AirScoreViewController: UIViewController {

    @IBOutlet var fullScreenView: UIView!
    @IBOutlet weak var airScoreLabel: UILabel!
    @IBOutlet weak var airScoreCircle: AirScoreView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var trailImageView: UIImageView!
    @IBOutlet weak var treadmillImageView: UIImageView!
    
    var cityNameTapped: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        airScoreCircle.isHidden = true
        cityLabel.numberOfLines = 0 // Allows multi-line
        messageLabel.numberOfLines = 0
        trailImageView.isHidden = true
        treadmillImageView.isHidden = true

        print("City name tapped: \(cityNameTapped)")
        showCityScore(cityName: cityNameTapped)
    }
    
    func showCityScore(cityName: String?) {
        
        let cityNameConcatenate = cityNameTapped?.removeWhitespace()
        
        AirQualClient.sharedInstance.getCityAirQuality(inputString: self.cityNameTapped!, inputStringConcatenate: cityNameConcatenate!) { (airQuality, error) in
            
            guard (error == nil) else {
                DispatchQueue.main.async {
                    self.airScoreCircle.isHidden = true
                    self.cityLabel.isHidden = true
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
                        self.cityLabel.text = self.cityNameTapped
                        self.messageLabel.text = "The air’s great! \nGo run your socks off!!"
                        self.treadmillImageView.isHidden = true
                        self.trailImageView.isHidden = false
                        self.airScoreCircle.color = UIColor(red: 0.6824, green: 1, blue: 0.4863, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! < 100 {
                    print("Moderate: yellow")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityNameTapped
                        self.messageLabel.text = "The air’s pretty good. \nGet in those miles!"
                        self.treadmillImageView.isHidden = true
                        self.trailImageView.isHidden = false
                        self.airScoreCircle.color = UIColor(red: 1, green: 0.9647, blue: 0.4863, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! < 150 {
                    print("Unhealthy for sensitive groups: orange")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityNameTapped
                        self.messageLabel.text = "The air’s okay. Take it easy out there, especially if you have asthma!"
                        self.treadmillImageView.isHidden = true
                        self.trailImageView.isHidden = false
                        self.airScoreCircle.color = UIColor(red: 1, green: 0.7843, blue: 0.4863, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! < 200 {
                    print("Unhealthy: red")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityNameTapped
                        self.messageLabel.text = "The air’s not great. Better stick to the treadmill!"
                        self.trailImageView.isHidden = true
                        self.treadmillImageView.isHidden = false
                        self.airScoreCircle.color = UIColor(red: 0.9569, green: 0.4667, blue: 0.4667, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! < 300 {
                    print("Very unhealthy: purple")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityNameTapped
                        self.messageLabel.text = "The air’s pretty polluted. Better stick to the treadmill, and avoid going out!"
                        self.trailImageView.isHidden = true
                        self.treadmillImageView.isHidden = false
                        self.airScoreCircle.color = UIColor(red: 0.651, green: 0.5059, blue: 0.7569, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                    }
                } else if airQuality! >= 300 {
                    print("Hazardous: brown")
                    
                    DispatchQueue.main.async {
                        self.airScoreCircle.isHidden = false
                        self.airScoreLabel.text = String(describing: airQuality!)
                        self.cityLabel.isHidden = false
                        self.cityLabel.text = self.cityNameTapped
                        self.messageLabel.text = "The air is dangerously polluted. Better stick to the treadmill, and keep your windows shut!"
                        self.trailImageView.isHidden = true
                        self.treadmillImageView.isHidden = false
                        self.airScoreCircle.color = UIColor(red: 0.6196, green: 0.5333, blue: 0.4118, alpha: 1.0)
                        self.airScoreCircle.setNeedsDisplay()
                    }
                }
                
            } else {
                
                DispatchQueue.main.async {
                    self.airScoreCircle.isHidden = true
                    self.cityLabel.isHidden = true
                    self.messageLabel.text = "Sorry, there is currently no data for \(self.cityNameTapped!). Go for a run anyway!"
                }
            }
        }
    }

}
