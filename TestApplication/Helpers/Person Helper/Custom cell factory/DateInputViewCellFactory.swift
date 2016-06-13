//
//  DateInputViewCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

struct DateInputViewCellFactory: AbstractFactory {

    func createCustomTableViewCell(
        attributeDescription: PersonAttributeDescription,
        personAttributeContainer: PersonAttributeContainer) -> CustomTableViewCell {

        return DateInputViewCell(
            attributeDescription: attributeDescription,
            attributeDictionary: personAttributeContainer.valuesDictionary,
            action: { (startDate, endDate) in
                let startDateKey = attributeDescription.key[0]
                let endDateKey = attributeDescription.key[1]
                personAttributeContainer.valuesDictionary[startDateKey] = startDate
                personAttributeContainer.valuesDictionary[endDateKey] = endDate
            },
            actionForClearField: {
                let startDateKey = attributeDescription.key[0]
                let endDateKey = attributeDescription.key[1]
                personAttributeContainer.valuesDictionary[startDateKey] = nil
                personAttributeContainer.valuesDictionary[endDateKey] = nil
        })
    }
}
