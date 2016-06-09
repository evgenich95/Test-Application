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

    private static func appropriateFactory(attributeDescription: PersonAttributeDescription) -> AbstractFactory {

        switch attributeDescription {
            case .FullName, .Salary, .WorkplaceNumber:
                return SimpleTextFieldCellFactory()
            case .AccountantType:
                return PickerInputViewCellFactory()
            case .MealTime:
                return DateInputViewCellFactory()
            default:
                fatalError("Invalid attributeDescription - \(attributeDescription)")
        }
    }

    static func cellsFor(attributeDictionary: [String: AnyObject]) -> [CustomTableViewCell] {

        var cells = [CustomTableViewCell]()

        for key in attributeDictionary.keys {
            guard
                let attributeDescription = PersonAttributeDescription(
                    attributeKey: key)
            else {
                fatalError("attributeKey - \(key) didn't describe in PersonAttributeDescription")
            }

            let factory = appropriateFactory(attributeDescription)
            cells.append(factory.createCustomTableViewCell(
                attributeDescription,
                attributeDictionary: attributeDictionary
                )
            )
        }
        return cells
    }
}
