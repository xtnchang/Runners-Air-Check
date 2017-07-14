//
//  AirViewController.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/13/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import UIKit

class AirViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        AirQualClient.sharedInstance.getCityAirQuality(cityName: "london") { (airQuality, error) in
            
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
