//
//  Employee.swift
//  TestApplication
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import BNRCoreDataStack

class Employee: NSManagedObject, CoreDataModelable {

    @NSManaged var fullName: String?
    @NSManaged var order: NSNumber?
    @NSManaged var salary: NSNumber?

    @NSManaged var sectionOrder: Int


    class var entityName: String {
        return "Employee"
    }

    var sectionName: String? {
        return self.entity.name
    }

    class var keys: [String] {
        var keys = [String]()
        keys.append(EmployeeAttributeKeys.fullName)
        keys.append(EmployeeAttributeKeys.salary)
        return keys
    }

    var valuesAttributeDictionary: [String: AnyObject] {
        guard let selfAttributeKeys = EmployeeType
                                        .init(aEmployee: self)?.attributeKeys
            else {
                fatalError("Employee's subcluss \(self.entity.name) doesn't have EmployeeType")
        }
        var valuesAttributeDictionary = [String: AnyObject]()

        for key in selfAttributeKeys {
            valuesAttributeDictionary[key] = self.valueForKey(key)
        }
        return valuesAttributeDictionary
    }

    func fillAttributes(dictionary: [String: AnyObject]) {
        for (key, value) in dictionary {
            self.setValue(value, forKey: key)
        }
    }
}
