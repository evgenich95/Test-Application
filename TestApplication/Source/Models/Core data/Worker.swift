//
//  Worker.swift
//  TestApplication
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

class Worker: Employee {
    @NSManaged var workplaceNumber: NSNumber?
    @NSManaged var startMealTime: NSDate?
    @NSManaged var endMealTime: NSDate?

    override class var entityName: String {
        return "Worker"
    }

    override class var keys: [String] {
        var keys = super.keys
        keys.append(EmployeeAttributeKeys.workplaceNumber)
        keys.append(EmployeeAttributeKeys.startMealTime)
        keys.append(EmployeeAttributeKeys.endMealTime)
        return keys
    }
}
