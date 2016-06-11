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

    static func cellsFor(personAttributeContainer: PersonAttributeContainer) -> [CustomTableViewCell] {

        var cells = [CustomTableViewCell]()

        for description in personAttributeContainer.attributeDescriptions {
            let factory = appropriateFactory(description)
            cells.append(factory.createCustomTableViewCell(
                description,
                personAttributeContainer: personAttributeContainer
                )
            )
        }
        return cells
    }
}
