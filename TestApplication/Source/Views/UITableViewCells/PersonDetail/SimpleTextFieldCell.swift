//
//  SimpleTextFieldCell.swift
//  TestApplication
//
//  Created by developer on 12.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class SimpleTextFieldCell: CustomTableViewCell {

    static let reuseIdentifier = "SimpleTextFieldCell"

    typealias ResultDataActionType = ((data: AnyObject) -> Void)
    var handleDataAction: ResultDataActionType?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(attributeDescription: PersonAttributeDescription,
                  valuesAttributeDictionary: [String : AnyObject],
                  action: ResultDataActionType,
                  actionForClearField: () -> Void) {

        super.updateUI(attributeDescription.type,
                     actionForClearField: actionForClearField)

        attributeDescriptionString = attributeDescription.description
        textFieldPlaceholder = attributeDescription.placeholder
        let data = valuesAttributeDictionary[attributeDescription.keys.first ?? ""]
        attributeValue = data
        handleDataAction = action
    }

    override func handleEnteringData(textField: UITextField) {
        guard let
            text = textField.text,
            inputType = inputDataType
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
