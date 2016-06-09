//
//  DateInputViewCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

class DateInputViewCellFactory: AbstractFactory {

    func createCustomTableViewCell(
        attributeDescription: PersonAttributeDescription,
        personAttributeDictionary: PersonAttributeDictionary) -> CustomTableViewCell {

        return DateInputViewCell(
            attributeDescription: attributeDescription,
            attributeDictionary: personAttributeDictionary.valuesDictionary,
            action: { (startDate, endDate) in
                let startDateKey = attributeDescription.key[0]
                let endDateKey = attributeDescription.key[1]
                personAttributeDictionary.valuesDictionary[startDateKey] = startDate
                personAttributeDictionary.valuesDictionary[endDateKey] = endDate
                print("personAttributeDictionary.valuesDictionary\n\(personAttributeDictionary.valuesDictionary)")
                //            self.person?.setValue(startDate, forKey: valueKeys[0])
                //            self.person?.setValue(endDate, forKey: valueKeys[1])
                //            self.addNewKeyForValid(valueKeys[0])
                //            self.addNewKeyForValid(valueKeys[1])
            },
            actionForClearField: {
                //            self.arrayOfFilledAttributes.removeObjectsInArray(valueKeys)
                //            self.checkValid()
        })
        
    }
}