//
//  Worker.swift
//  TestApplication
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

class Worker: Person {
    @NSManaged var workplaceNumber: NSNumber?
    @NSManaged var startMealTime: NSDate?
    @NSManaged var endMealTime: NSDate?

    override class var entityName: String {
        return "Worker"
    }

    override class var keys: [String] {
        var keys = super.keys
        keys.append(PersonAttributeKeys.workplaceNumber)
        keys.append(PersonAttributeKeys.startMealTime)
        keys.append(PersonAttributeKeys.endMealTime)
        return keys
    }
}
