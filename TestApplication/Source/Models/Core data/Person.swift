//
//  Person.swift
//  TestApplication
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import BNRCoreDataStack

class Person: NSManagedObject, CoreDataModelable {

    @NSManaged var fullName: String?
    @NSManaged var order: NSNumber?
    @NSManaged var salary: NSNumber?

    class var entityName: String {
        return "Person"
    }

    class var keys: [String] {
        var keys = [String]()
        keys.append(PersonAttributeKeys.fullName)
        keys.append(PersonAttributeKeys.salary)
        return keys
    }

    var attributeDictionary: [String: AnyObject] {
        guard let selfAttributeKeys = PersonTypeRecognizer
                                        .init(aPerson: self)?.attributeKeys
            else {
                fatalError("Person's subcluss \(self.entity.name) doesn't have PersonTypeRecognizer")
        }
        var attributeDictionary = [String: AnyObject]()

        for key in selfAttributeKeys {
            attributeDictionary[key] = self.valueForKey(key)
        }
        return attributeDictionary
    }

    func fillAttributes(dictionary: [String: AnyObject]) {
        for (key, value) in dictionary {
            self.setValue(value, forKey: key)
        }
    }
}
