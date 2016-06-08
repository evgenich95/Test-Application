//
//  CustomCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

enum CustomCellFactory {
    static func cellFor(attributeKey: String, attributeValue: AnyObject) -> UITableViewCell {
        guard let attributeDescription = PersonAttributeDescription(attributeKey: attributeKey)
            else {
                fatalError("invalid attribute \(attributeKey)")
        }

        switch attributeDescription {
        case .FullName, .Salary, .WorkplaceNumber:
            return SimpleTextFieldCell(
                description: [
                    attributeDescription.description,
                    attributeDescription.placeholder
                ],
                data: attributeValue,

                action: { (data) in
//                    self.personAttributeDictionary[attributeKey] = data
                    //                    self.person?.setValue(data, forKey: personAttribute.name)
                    //                    self.addNewKeyForValid(personAttribute.name)
                },
                actionForClearField: {
                    //                    self.arrayOfFilledAttributes.removeObject(personAttribute.name)
                    //                    self.checkValid()
            })
        default:
            return UITableViewCell()
        }
    }
}