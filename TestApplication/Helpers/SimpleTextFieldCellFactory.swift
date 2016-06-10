//
//  SimpleTextFieldCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

class SimpleTextFieldCellFactory: AbstractFactory {

    func createCustomTableViewCell(
        attributeDescription: PersonAttributeDescription,
        personAttributeDictionary: PersonAttributeDictionary) -> CustomTableViewCell {
        return SimpleTextFieldCell(
            attributeDescription: attributeDescription,
            attributeDictionary: personAttributeDictionary.valuesDictionary,
            action: { (data) in
                let key = attributeDescription.key.first ?? ""
                 personAttributeDictionary.valuesDictionary[key] = data
            },
            actionForClearField: {

                let key = attributeDescription.key.first ?? ""
                personAttributeDictionary.valuesDictionary[key] = nil
        })
    }
}
