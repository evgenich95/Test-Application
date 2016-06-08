//
//  Manager.swift
//  TestApplication
//
//  Created by developer on 07.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData


class Manager: Person {
    @NSManaged var startVisitingHours: NSDate?
    @NSManaged var endVisitingHours: NSDate?

    override class var entityName: String {
        return "Manager"
    }

    override var attributeDictionary: [String : AnyObject] {
        var attributeDictionary = super.attributeDictionary

        attributeDictionary[PersonAttributeKeys.startVisitingHours] = startVisitingHours
        attributeDictionary[PersonAttributeKeys.endVisitingHours] = endVisitingHours

        return attributeDictionary
    }
}
