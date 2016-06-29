//
//  Manager.swift
//  TestApplication
//
//  Created by developer on 07.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

class Manager: Employee {
    @NSManaged var startVisitingHours: NSDate?
    @NSManaged var endVisitingHours: NSDate?

    override class var entityName: String {
        return "Manager"
    }

    override class var keys: [String] {
        var keys = super.keys
        keys.append(EmployeeAttributeKeys.startVisitingHours)
        keys.append(EmployeeAttributeKeys.endVisitingHours)
        return keys
    }
}
