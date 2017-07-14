//
//  AirQualConstants.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/13/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import Foundation

extension AirQualClient {
    
    struct Constants {
        
        static let APIScheme = "https://"
        static let APIHost = "api.waqi.info"
        static let APISearchPath = "/search"
    }
    
    struct AirQualParameterKeys {
        
        static let Token = "/?token="
        static let Keyword = "keyword="
    }
    
    struct AirQualParameterValues {
        
        static let Token = "42507480451ec3dbed7ad60e6cf0528daba22dda"
    }
    
    struct AirQualResponseKeys {
        
        static let Status = "status"
        static let Data = "data"
        static let Url = "url"
        static let AirQualityIndex = "aqi"
    }
    
    struct AirQualResponseValues {
        
        static let OKStatus = "ok"
    }
    
}
