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

        print("factory for \(attributeDescription)")
        switch attributeDescription {
            case .FullName, .Salary, .WorkplaceNumber:
                return SimpleTextFieldCellFactory()
            case .AccountantType:
                return PickerInputViewCellFactory()
            case .MealTime, .VisitingHours:
                return DateInputViewCellFactory()
        }
    }

    static func cellsFor(personAttributeDictionary: PersonAttributeDictionary) -> [CustomTableViewCell] {
//        print("\n\nCustomCellFactory.cellsFor")
//        print("Person type = \(displayedPersonType!.description)")

        var cells = [CustomTableViewCell]()

        for description in personAttributeDictionary.attributeDescriptions {
            let factory = appropriateFactory(description)
            cells.append(factory.createCustomTableViewCell(
                description,
                personAttributeDictionary: personAttributeDictionary
                )
            )
        }
        return cells
    }
}
