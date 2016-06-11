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
        personAttributeContainer: PersonAttributeContainer) -> CustomTableViewCell {

        return PickerInputViewCell(
            attributeDescription: attributeDescription,
            attributeDictionary: personAttributeContainer.valuesDictionary,
            action: { (data) in
                let key = attributeDescription.key.first ?? ""
                personAttributeContainer.valuesDictionary[key] = data
//                print("personAttributeContainer.valuesDictionary\n\(personAttributeContainer.valuesDictionary)")
                //                self.person?.setValue(data, forKey: personAttribute.name)
                //                self.addNewKeyForValid(personAttribute.name)
            },
            actionForClearField: {
                let key = attributeDescription.key.first ?? ""
                personAttributeContainer.valuesDictionary[key] = nil
        })
    }
}
