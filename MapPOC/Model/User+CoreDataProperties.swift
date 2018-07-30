//
//  User+CoreDataProperties.swift
//  MapPOC
//
//  Created by Ankleshwar on 30/07/18.
//  Copyright © 2018 Ankleshwar. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double

}
