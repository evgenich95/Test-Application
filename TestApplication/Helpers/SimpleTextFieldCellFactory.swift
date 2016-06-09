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
            attributeDescription: attributeDescription,
            attributeDictionary: attributeDictionary,
            action: { (data) in

            },
            actionForClearField: {

        })
    }
}
