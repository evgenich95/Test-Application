//
//  SimpleTextFieldCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

struct SimpleTextFieldCellFactory: AbstractFactory {

    func createCustomTableViewCell(
        attributeDescription: PersonAttributeDescription,
        personAttributeContainer: PersonAttributeContainer) -> CustomTableViewCell {

        return SimpleTextFieldCell(
            attributeDescription: attributeDescription,
            attributeDictionary: personAttributeContainer.valuesDictionary,
            action: { (data) in
                let key = attributeDescription.keys.first ?? ""
                personAttributeContainer.valuesDictionary[key] = data
            },
            actionForClearField: {
                let key = attributeDescription.keys.first ?? ""
                personAttributeContainer.valuesDictionary[key] = nil
        })
    }
}
