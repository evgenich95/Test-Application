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
            case .MealTime, .VisitingHours:
                return DateInputViewCellFactory()
        }
    }

    static func cellsFor(displayedPersonType: PersonTypeRecognizer?,
                         attributeDictionary: [String: AnyObject]) -> [CustomTableViewCell] {

        var cells = [CustomTableViewCell]()
        var keys = Array(attributeDictionary.keys)

        if  attributeDictionary.isEmpty,
            let attributeKeys = displayedPersonType?.attributeKeys {
            keys = attributeKeys
        }

        for key in keys {
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
