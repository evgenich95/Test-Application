//
//  PickerInputViewCell.swift
//  TestApplication
//
//  Created by developer on 13.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class PickerInputViewCell: CustomTableViewCell {

    typealias ResultDataActionType = ((data: AnyObject) -> Void)?
    var handleDataAction: ResultDataActionType

    var currentValue: AnyObject? {
        willSet {
            if let data = newValue as? NSNumber {
                pickerView.selectRow(data.integerValue, inComponent: 0, animated: false)
                attributeValue = AccountantType.init(index: data.integerValue).description
            }
        }
    }

    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()

    init(attributeDescription: PersonAttributeDescription,
         attributeDictionary: [String : AnyObject],
         action: ResultDataActionType,
         actionForClearField: () -> Void) {

        defer {
            let data = attributeDictionary[attributeDescription.key.first ?? ""]
            self.currentValue = data
        }

        super.init(actionForClearField: actionForClearField)

        self.attributeDescriptionString = attributeDescription.description
        self.textFieldPlaceholder = attributeDescription.placeholder
        self.handleDataAction = action

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Help functions
    func setupView() {
        dataTextFieldInputView = self.pickerView
    }
    override func handleEnteringData(textField: UITextField) {
        if let type = currentValue {
            handleDataAction?(data: type )
        }
    }

//    override func textFieldDidEndEditing(textField: UITextField) {
//        super.textFieldDidEndEditing(textField)
//        if let type = currentValue {
//            handleDataAction?(data: type )
//        }
//    }
}

extension PickerInputViewCell: UIPickerViewDelegate {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AccountantType.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AccountantType(index: row).description
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentValue = row
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
