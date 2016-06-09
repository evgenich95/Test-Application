//
//  Person.swift
//  TestApplication
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
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

    var entityOrderIndex: Int {
        switch self.entity.userInfo?["orderIndex"] {
        case let (orderIndex as NSString):
            return orderIndex.integerValue
        default:
            fatalError("\(self.entity.name) is missing \"orderIndex\" user info key")
        }
    }

//    var attributeDictionary: [String: AnyObject] {
//        var attributeDictionary = [String: AnyObject]()
//
//        attributeDictionary[PersonAttributeKeys.fullName] = fullName
//        attributeDictionary[PersonAttributeKeys.salary] = salary
//
//        return attributeDictionary
//    }

    var attributeDictionary: [String: AnyObject] {
        guard let selfAttributeKeys = PersonTypeRecognizer.init(aPerson: self)?
            .attributeKeys
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
    
    lazy var personDisplayedAttributeKeys: [String] = {
        var personKeys = [String]()
        let allAttributes = self.entity.propertiesByName

        for (key, propertyDescription) in allAttributes {
            if let _ = propertyDescription.userInfo?[UserInfoKeys.attributeOrderIndex] {
                personKeys.append(key)
            }
        }
        return personKeys
    }()

    lazy private var aggregateAttribute: NSAttributeDescription = {
        let allAttributes = self.entity.attributesByName.values

        //отобрали все составные атрибуты и отсортировали
        //по установленому порядку userInfo["aggregate"]
        //чтобы знать какому порядковому ключу какое значение соответствует
        //startDate = 0; endData = 1
        let partsOfAggregateAttributes = (allAttributes.filter { (param) in
            if let _ = param.userInfo?["aggregate"] as? NSString {
                return true
            }
            return false }).sort { (first, second) in
                                    guard
                                        let firstIndex = first.userInfo?["aggregate"] as? NSString,
                                            secondIndex = second.userInfo?["aggregate"] as? NSString
                                        else {return false}

                                    if firstIndex.integerValue < secondIndex.integerValue {
                                        return true
                                    }
                                    return false
        }

        let aggregateAttribute = NSAttributeDescription()
        //помечаем, что атрибут сосоставной
        aggregateAttribute.optional = true

        //кладём в него ключи, чтобы можно было получить
        //значения частей
        var keys = [String]()
        for atr in partsOfAggregateAttributes {
            keys.append(atr.name)
        }

        guard let type =  partsOfAggregateAttributes.first?.attributeType
            else {
                fatalError("Attribute \(partsOfAggregateAttributes.first?.name)parts of AggregateAttributes don't have type ")
        }

        aggregateAttribute.attributeType = type
        aggregateAttribute.name = "Составной атрибут"

        // swiftlint:disable line_length
        aggregateAttribute.userInfo?["keys"] = keys

        aggregateAttribute.userInfo?[UserInfoKeys.attributeDescription] = partsOfAggregateAttributes.first?.userInfo?[UserInfoKeys.attributeDescription]

        aggregateAttribute.userInfo?[UserInfoKeys.attributePlaceholder] = partsOfAggregateAttributes.first?.userInfo?[UserInfoKeys.attributePlaceholder]
        // swiftlint:enable line_length

        return aggregateAttribute
    }()

    lazy var personAttributesByName: [NSAttributeDescription] = {
        let allAttributes = self.entity.attributesByName.values

        //получили все не составные атрибуты
        //у которых установлен "orderIndex" в userInfo
        let attributesWithOrderIndex = allAttributes.filter { (param) in
            if let _ = param.userInfo?["aggregate"] {
                return false
            }
            if let _ = param.userInfo?[UserInfoKeys.attributeOrderIndex] {
                return true
            }
            return false
        }

        //отсортировали атрибуты в порядке вывода на экран
        var sortedAttributesByOrderIndex = attributesWithOrderIndex.sort { (first, second) -> Bool in
            switch (first.userInfo?[UserInfoKeys.attributeOrderIndex],
                second.userInfo?[UserInfoKeys.attributeOrderIndex]) {
            case let (firstIndex?, secondIndex?):
                if firstIndex.integerValue < secondIndex.integerValue {
                    return true
                }
                return false
            default:
                fatalError(" Attributes \(first.name) and \(second.name) don't have key =='orderIndex' in userInfo")
            }
        }
        //получаем составные атрибуты объекта Person
        //и добавляем в конец всех остальных
        let aggregate = self.aggregateAttribute
        sortedAttributesByOrderIndex.append(aggregate)

        return sortedAttributesByOrderIndex
    }()

    func copyAttributesFrom(from: Person) {

        let fromKeys = from.entity.attributesByName.keys
        let toKeys = self.entity.attributesByName.keys

        for key in fromKeys {
            if toKeys.contains(key) {
                self.setValue(from.valueForKey(key), forKey: key)
            }
        }
    }
}
