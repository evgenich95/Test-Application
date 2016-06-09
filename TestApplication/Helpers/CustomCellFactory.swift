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

//        var keys = displayedPersonType?.attributeKeys ?? [String]()

//        print("his keys.count = \(keys.count)")

//        keys.removeObjectsInArray(notDisplayedAttributes)
//        
//        for key in keys {
//            guard
//                let attributeDescription = PersonAttributeDescription(
//                    attributeKey: key)
//            else {
//                fatalError("attributeKey - \(key) didn't describe in PersonAttributeDescription")
//            }

        for description in personAttributeDictionary.attributeDescriptions {
            let factory = appropriateFactory(description)
            cells.append(factory.createCustomTableViewCell(
                description,
                attributeDictionary: personAttributeDictionary.valuesDictionary
                )
            )
        }
        return cells
    }
}
