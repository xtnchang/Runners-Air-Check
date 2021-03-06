//
//  AirQualConvenience.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/13/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import Foundation

extension AirQualClient {

    func getCityAirQuality(inputString: String, inputStringConcatenate: String, completionHandlerForData: @escaping (_ airQuality: Int?, _ error: NSError?) -> Void) {
        
        let parameter = inputStringConcatenate
        
        // Sample URL: https://api.waqi.info/search/?token=42507480451ec3dbed7ad60e6cf0528daba22dda&keyword=losangeles
        
        taskForGETMethod(parameter: parameter) { (deserializedData, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForData(nil, NSError(domain: "completionHandlerForGET", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard (deserializedData != nil) else {
                sendError(error: "No results were found.")
                return
            }
            
            guard let status = deserializedData?[AirQualResponseKeys.Status] as? String, status == AirQualResponseValues.OKStatus else {
                sendError(error: "Air Quality API returned an error. See error code and message in \(deserializedData)")
                return
            }
            
            guard let data = deserializedData?[AirQualResponseKeys.Data] as? [AnyObject] else {
                sendError(error: "The 'data' key cannot be found.")
                return
            }
            
            if data.isEmpty {
                sendError(error: "Sorry, there is currently no data for \(inputString). Go for a run anyway!")
                return
            }
            
            guard let dictionary = data[0] as? [String:AnyObject] else {
                sendError(error: "The dictionary cannot be found.")
                return
            }
            
            var aqiString = ""
            
            guard let aqiString_0 = dictionary[AirQualResponseKeys.AirQualityIndex] as? String else {
                sendError(error: "The 'aqi' key cannot be found.")
                return
            }
            
            aqiString = aqiString_0
            
            // In some cases, the first aqi value in the array of dictionaries is "".
            if aqiString == "" && data.count > 1 {
                
                var i = 1
                
                while aqiString == "" {
                    
                    guard let dictionary = data[i] as? [String:AnyObject] else {
                        sendError(error: "The dictionary cannot be found.")
                        return
                    }
                    guard let aqiString_1 = dictionary[AirQualResponseKeys.AirQualityIndex] as? String else {
                        sendError(error: "The 'aqi' key cannot be found.")
                        return
                    }
                    
                    i += 1
                    
                    aqiString = aqiString_1
                }
            }
            
            let airQuality = Int(aqiString)
            
            completionHandlerForData(airQuality, nil)
        }
        
    }
}
