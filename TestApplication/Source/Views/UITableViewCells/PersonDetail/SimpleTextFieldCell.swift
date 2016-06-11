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

        self.attributeDescriptionString = attributeDescription.description
        self.textFieldPlaceholder = attributeDescription.placeholder
        let data = attributeDictionary[attributeDescription.key.first ?? ""]
        self.attributeValue = data
        self.handleDataAction = action
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

//    override func textFieldDidEndEditing(textField: UITextField) {
//        super.textFieldDidEndEditing(textField)
//        if textField.text?.characters.count < 1 {
//            return
//        }
//
//        if let text =  textField.text {
//            if inputDataType == .StringAttributeType {
//                handleDataAction?(data: text)
//            } else {
//                if let integerValue = Int(text) {
//                    handleDataAction?(data: NSNumber(integer: integerValue))
//                }
//            }
//        }
//    }
        if let data = returnData {
            handleDataAction?(data: data)
        }
    }
}
