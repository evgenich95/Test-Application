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

    init(description: [String]?,
         data: AnyObject?,
         inputDataType: NSAttributeType = .StringAttributeType,
         action: ResultDataActionType,
         actionForClearField: () -> Void) {

        super.init(inputDataType: inputDataType, actionForClearField: actionForClearField)

        self.attributeDescriptionString = description
        self.attributeValueString = data
        self.handleDataAction = action
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textFieldDidEndEditing(textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        if textField.text?.characters.count < 1 {
            return
        }

        if let text =  textField.text {
            if inputDataType == .StringAttributeType {
                handleDataAction?(data: text)
            } else {
                if let integerValue = Int(text) {
                    handleDataAction?(data: NSNumber(integer: integerValue))
                }
            }
        }
    }
}
