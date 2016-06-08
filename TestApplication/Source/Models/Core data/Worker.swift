//
//  Worker.swift
//  TestApplication
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData


class Worker: Person {
    @NSManaged var workplaceNumber: NSNumber?
    @NSManaged var startMealTime: NSDate?
    @NSManaged var endMealTime: NSDate?

    override class var entityName: String {
        return "Worker"
    }

    override var attributeDictionary: [String : AnyObject] {
        var attributeDictionary = super.attributeDictionary

        attributeDictionary["workplaceNumber"] = workplaceNumber
        attributeDictionary["startMealTime"] = startMealTime
        attributeDictionary["endMealTime"] = endMealTime
    
        print("Worker.attributeDictionary = \(attributeDictionary)")
        return attributeDictionary
    }
}
