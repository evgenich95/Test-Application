//
//  PickerInputViewCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

class PickerInputViewCellFactory: AbstractFactory {

    func createCustomTableViewCell(
        attributeDescription: PersonAttributeDescription,
        personAttributeDictionary: PersonAttributeDictionary) -> CustomTableViewCell {

        return PickerInputViewCell(
            attributeDescription: attributeDescription,
            attributeDictionary: personAttributeDictionary.valuesDictionary,
            action: { (data) in
                let key = attributeDescription.key.first ?? ""
                personAttributeDictionary.valuesDictionary[key] = data
                print("personAttributeDictionary.valuesDictionary\n\(personAttributeDictionary.valuesDictionary)")
                //                self.person?.setValue(data, forKey: personAttribute.name)
                //                self.addNewKeyForValid(personAttribute.name)
            },
            actionForClearField: {
                let key = attributeDescription.key.first ?? ""
                personAttributeDictionary.valuesDictionary[key] = nil
        })
    }
}
