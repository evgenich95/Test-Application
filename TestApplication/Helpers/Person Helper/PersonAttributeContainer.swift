//
//  AttributeDictionary.swift
//  TestApplication
//
//  Created by developer on 09.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

protocol PersonAttributeContainerDelegate {
    func userEnteredData()
}

class PersonAttributeContainer {

    //MARK: Parameters
    var delegate: PersonAttributeContainerDelegate?
    var displayedPersonType: PersonTypeRecognizer {
        didSet {
            updateValuesDictionary()
            updateAttributeDescriptions()
        }
    }

    var valuesDictionary = [String: AnyObject]() {
        didSet {
            delegate?.userEnteredData()
        }
    }

    var attributeDescriptions = [PersonAttributeDescription]()
    //MARK:-

    init(displayedPersonType: PersonTypeRecognizer, aPerson: Person?) {
        self.displayedPersonType = displayedPersonType
        updateAttributeDescriptions()

        guard let person = aPerson
            else {return}
        for key in displayedPersonType.attributeKeys {
            valuesDictionary[key] = person.valueForKey(key)
        }
    }

    func updateAttributeDescriptions() {
        attributeDescriptions.removeAll()
        for key in displayedPersonType.attributeKeys {
            if let description = PersonAttributeDescription(attributeKey: key) {
                if !attributeDescriptions.contains(description) {
                    attributeDescriptions.append(description)
                }
            }
        }
    }

    func updateValuesDictionary() {
        for key in valuesDictionary.keys {
            if !displayedPersonType.attributeKeys.contains(key) {
                valuesDictionary[key] = nil
            }
        }
    }
}
