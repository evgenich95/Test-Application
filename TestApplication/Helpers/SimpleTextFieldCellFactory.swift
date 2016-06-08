//
//  SimpleTextFieldCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

class SimpleTextFieldCellFactory: AbstractFactory {

    func createCustomTableViewCell(attributeDescription: PersonAttributeDescription, attributeDictionary: [String: AnyObject]) -> CustomTableViewCell {
        return SimpleTextFieldCell(
            description: [
                attributeDescription.description,
                attributeDescription.placeholder
            ],
            data: attributeDictionary[attributeDescription.key.first ?? ""],

            action: { (data) in

            },
            actionForClearField: {

        })
    }
}
