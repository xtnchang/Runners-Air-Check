//
//  AirQualClient.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/13/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import Foundation

class AirQualClient {
    
    func taskForGETMethod(parameter: String, completionHandlerForGET: @escaping (_ deserializedData: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        let urlString = Constants.APIScheme + Constants.APIHost + Constants.APISearchPath + AirQualParameterKeys.Token + AirQualParameterValues.Token + "&" + AirQualParameterKeys.Keyword + parameter
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error: "\(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            // Parse raw JSON and pass values for (deserializedData, error) to completionHandlerForGET, rather than the traditional "in" followed by a code block. This has the effect of "bubbling up" the completion handler arguments.
            self.parseJSONWithCompletionHandler(data, completionHandlerForParsingJSON: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    private func parseJSONWithCompletionHandler(_ data: Data, completionHandlerForParsingJSON: (_ deserializedData: AnyObject?, _ error: NSError?) -> Void) {
        
        var deserializedData: AnyObject! = nil
        do {
            deserializedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            // If there's an error, the completion handler is passed the arguments below.
            completionHandlerForParsingJSON(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        // If there's no error, the completion handler is passed the arguments below.
        completionHandlerForParsingJSON(deserializedData, nil)
    }
    
    static var sharedInstance = AirQualClient()
    
}
