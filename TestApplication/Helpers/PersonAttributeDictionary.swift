//
//  AttributeDictionary.swift
//  TestApplication
//
//  Created by developer on 09.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

protocol DelegateForPersonAttributeDictionary {
//    func cellBeginEditing()
//    func cellDidEndEditing()
    func userEnteredData()
    
}

class PersonAttributeDictionary {

    var delegate: DelegateForPersonAttributeDictionary?
    var displayedPersonType: PersonTypeRecognizer {
        didSet {
            print("обновляю словарь значений)")
            print("Текущий отображ. тип изменился с \(oldValue) на \(displayedPersonType)")
            updateValuesDictionary()
            updateAttributeDescriptions()
        }
    }
    var attributeDescriptions = [PersonAttributeDescription]()

    var valuesDictionary = [String: AnyObject]() {
        didSet {
            print("----\nvaluesDictionary.didSet ")
            delegate?.userEnteredData()
            print("valuesDictionary = \(valuesDictionary)\n------")
        }
    }

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
        print("\nupdateValuesDictionary")
        print("valuesDictionary = \(valuesDictionary)")
        for key in valuesDictionary.keys {
            if !displayedPersonType.attributeKeys.contains(key) {
                valuesDictionary[key] = nil
                print("убрал ключ \(key) из нового словаря значений")
            }
        }
        print("\n\n")
    }
}
