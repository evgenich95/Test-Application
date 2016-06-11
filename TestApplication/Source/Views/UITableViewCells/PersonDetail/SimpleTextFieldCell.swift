//
//  SimpleTextFieldCell.swift
//  TestApplication
//
//  Created by developer on 12.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

class SimpleTextFieldCell: CustomTableViewCell {

    typealias ResultDataActionType = ((data: AnyObject) -> Void)?
    var handleDataAction: ResultDataActionType

    init(attributeDescription: PersonAttributeDescription,
         attributeDictionary: [String : AnyObject],
         action: ResultDataActionType,
         actionForClearField: () -> Void) {

        super.init(inputDataType: attributeDescription.type, actionForClearField: actionForClearField)

        attributeDescriptionString = attributeDescription.description
        textFieldPlaceholder = attributeDescription.placeholder
        let data = attributeDictionary[attributeDescription.key.first ?? ""]
        attributeValue = data
        handleDataAction = action
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func handleEnteringData(textField: UITextField) {

        guard
        let text = textField.text,
        let inputType = inputDataType
            else {return}

        var returnData: AnyObject?

        switch inputType {
            case .StringAttributeType:
                returnData = text
            case .DoubleAttributeType:
                returnData = (text as NSString).doubleValue
            case .Integer32AttributeType:
                returnData = (text as NSString).integerValue
        default:
            fatalError("Invalid input data type for attribute \(attributeDescriptionString)")
        }

        if let data = returnData {
            handleDataAction?(data: data)
        }
    }
}
