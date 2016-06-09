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

        attributeDictionary[PersonAttributeKeys.workplaceNumber] = workplaceNumber
        attributeDictionary[PersonAttributeKeys.startMealTime] = startMealTime
        attributeDictionary[PersonAttributeKeys.endMealTime] = endMealTime
    
        print("Worker.attributeDictionary = \(attributeDictionary)")
        return attributeDictionary
    override class var keys: [String] {
        var keys = super.keys
        keys.append(PersonAttributeKeys.workplaceNumber)
        keys.append(PersonAttributeKeys.startMealTime)
        keys.append(PersonAttributeKeys.endMealTime)
        return keys
    }
}
