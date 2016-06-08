//
//  DateInputViewCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

class DateInputViewCellFactory {

    func createCustomTableViewCell(attributeDescription: PersonAttributeDescription, attributeDictionary: [String: AnyObject]) -> CustomTableViewCell {

        return DateInputViewCell(
            description: [
                attributeDescription.description,
                attributeDescription.placeholder
            ],
            startTime: attributeDictionary[attributeDescription.key[0]] as? NSDate,
            endTime: attributeDictionary[attributeDescription.key[1]] as? NSDate,
            action: { (startDate, endDate) in
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