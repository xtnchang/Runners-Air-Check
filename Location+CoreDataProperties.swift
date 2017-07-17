//
//  Location+CoreDataProperties.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/17/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var city: String?

}
