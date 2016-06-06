//
//  TableViewCellWithPickerInputView.swift
//  TestApplication
//
//  Created by developer on 13.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class TableViewCellWithPickerInputView: CustomTableViewCell {

    typealias ResultDataActionType = ((data: AnyObject) -> Void)?
    var handleDataAction: ResultDataActionType

    var currentType: AnyObject? {
        willSet {
            if let data = newValue as? NSNumber {
                pickerView.selectRow(data.integerValue, inComponent: 0, animated: false)
                attributeValueString = BookkeepingType.init(index: data.integerValue).description
            }
        }
    }

    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()

    init(description: [String],
         data: AnyObject?,
         action: ResultDataActionType,
         actionForClearField: () -> Void) {
        defer {
            self.currentType = data
        }

        super.init(actionForClearField: actionForClearField)

        self.attributeDescriptionString = description
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

    override func textFieldDidEndEditing(textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        if let type = currentType {
            handleDataAction?(data: type )
        }
    }
}

extension TableViewCellWithPickerInputView: UIPickerViewDelegate {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BookkeepingType.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BookkeepingType(index: row).description
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentType = row
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
