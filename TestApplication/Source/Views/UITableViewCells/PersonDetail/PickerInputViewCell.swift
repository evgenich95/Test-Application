//
//  PickerInputViewCell.swift
//  TestApplication
//
//  Created by developer on 13.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class PickerInputViewCell: CustomTableViewCell {

    static let reuseIdentifier = "PickerInputViewCell"

    typealias ResultDataActionType = ((data: AnyObject) -> Void)?
    var handleDataAction: ResultDataActionType
    var values = [String]()

    private var currentValue: AnyObject? {
        didSet {
            if let data = currentValue as? NSNumber {
                pickerView.selectRow(data.integerValue,
                                     inComponent: 0,
                                     animated: false)
                guard let possibleValues = EmployeeAttribute
                                                    .AccountantType
                                                    .possibleValues
                    where possibleValues.count > 0
                    else {fatalError()}

                guard let text = possibleValues[data.integerValue] as? String else {fatalError()}

                attributeValue = text
            }
        }
    }

    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.whiteColor()
        picker.delegate = self
        return picker
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        currentValue = nil
        attributeValue = nil
    }

    //MARK: Help functions

    func updateUI(attributeDescription: EmployeeAttribute,
                  valuesAttributeDictionary: [String : AnyObject],
                  action: ResultDataActionType,
                  actionForClearField: () -> Void) {

        super.updateUI(attributeDescription.type,
                       actionForClearField: actionForClearField)

        defer {
            let data = valuesAttributeDictionary[attributeDescription.keys.first ?? ""]
            self.currentValue = data
        }

        self.attributeDescriptionString = attributeDescription.description
        self.textFieldPlaceholder = attributeDescription.placeholder
        self.handleDataAction = action

        if let numberValues = attributeDescription.possibleValues as? [NSNumber] {
            self.values = numberValues.map {$0.stringValue}
        } else if let numberValues = attributeDescription.possibleValues as? [String] {
            self.values =  numberValues
        } else {
            fatalError("Possible values for attribute \(attributeDescription.description) must be filled")
        }
    }

    func setupView() {
        dataTextFieldInputView = self.pickerView
    }

    override func handleEnteringData(textField: UITextField) {
        if let type = currentValue {
            handleDataAction?(data: type )
        }
    }

    override func textField(textField: UITextField,
                            shouldChangeCharactersInRange range: NSRange,
                            replacementString string: String) -> Bool {
        return false
    }
}

extension PickerInputViewCell: UIPickerViewDelegate {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }

    func pickerView(pickerView: UIPickerView,
                    titleForRow row: Int,
                                forComponent component: Int) -> String? {
        return values[row]
    }

    func pickerView(pickerView: UIPickerView,
                    didSelectRow row: Int,
                                 inComponent component: Int) {
        currentValue = row
    }
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
