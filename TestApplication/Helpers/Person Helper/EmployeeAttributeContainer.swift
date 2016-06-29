//
//  AttributeDictionary.swift
//  TestApplication
//
//  Created by developer on 09.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

protocol EmployeeAttributeContainerDelegate {
    func employeeAttributeContainerDidEnterData(
        container: EmployeeAttributeContainer)
}

class EmployeeAttributeContainer {

    //MARK: Parameters
    var delegate: EmployeeAttributeContainerDelegate?

    var displayedEmployeeType: EmployeeType {
        didSet {
            updateValuesDictionary()
            updateAttributeDescriptions()
        }
    }

    var valuesDictionary = [String: AnyObject]() {
        didSet {
            delegate?.employeeAttributeContainerDidEnterData(self)
        }
    }

    var attributeDescriptions = [EmployeeAttribute]()
    //MARK:-

    init(displayedEmployeeType: EmployeeType, aEmployee: Employee?) {
        self.displayedEmployeeType = displayedEmployeeType
        updateAttributeDescriptions()

        guard let employee = aEmployee
            else {return}
        for key in displayedEmployeeType.attributeKeys {
            valuesDictionary[key] = employee.valueForKey(key)
        }
    }

    func updateAttributeDescriptions() {
        attributeDescriptions.removeAll()
        for key in displayedEmployeeType.attributeKeys {
            if let description = EmployeeAttribute(attributeKey: key) {
                if !attributeDescriptions.contains(description) {
                    attributeDescriptions.append(description)
                }
            }
        }
    }

    func updateValuesDictionary() {
        for key in valuesDictionary.keys {
            if !displayedEmployeeType.attributeKeys.contains(key) {
                valuesDictionary[key] = nil
            }
        }
    }
}
