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

    static func cellFor(attributeDescription: PersonAttributeDescription, attributeDictionary: [String: AnyObject]) -> UITableViewCell {

        switch attributeDescription {
        case .FullName, .Salary, .WorkplaceNumber:
            return SimpleTextFieldCellFactory()
                .createCustomTableViewCell(
                    attributeDescription,
                    attributeDictionary: attributeDictionary
            )
        case .AccountantType:
            return PickerInputViewCellFactory()
                .createCustomTableViewCell(
                    attributeDescription,
                    attributeDictionary: attributeDictionary
            )
        case .MealTime:
            return DateInputViewCellFactory()
            .createCustomTableViewCell(
                attributeDescription, attributeDictionary: attributeDictionary
            )

            
        default:
            return UITableViewCell()
        }
    }
}
