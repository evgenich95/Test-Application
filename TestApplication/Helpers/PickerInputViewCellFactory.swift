//
//  PickerInputViewCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

class PickerInputViewCellFactory: AbstractFactory {

    func createCustomTableViewCell(attributeDescription: PersonAttributeDescription, attributeDictionary: [String: AnyObject]) -> CustomTableViewCell {

        return PickerInputViewCell(
            description: [
                attributeDescription.description,
                attributeDescription.placeholder
            ],
            data: attributeDictionary[attributeDescription.rawValue],
            action: { (data) in
//                self.person?.setValue(data, forKey: personAttribute.name)
//                self.addNewKeyForValid(personAttribute.name)
            },
            actionForClearField: {
//                self.arrayOfFilledAttributes.removeObject(personAttribute.name)
//                self.checkValid()
        })


}
}