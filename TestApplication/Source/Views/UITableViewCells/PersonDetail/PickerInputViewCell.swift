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

    private var currentValue: AnyObject? {
        didSet {
            if let data = currentValue as? NSNumber {
                pickerView.selectRow(data.integerValue,
                                     inComponent: 0,
                                     animated: false)
                attributeValue = AccountantType
                                    .init(index: data.integerValue).description
            }
        }
    }

    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()

    func updateUI(attributeDescription: PersonAttributeDescription,
                  attributeDictionary: [String : AnyObject],
                  action: ResultDataActionType,
                  actionForClearField: () -> Void) {

        super.update(attributeDescription.type,
                     actionForClearField: actionForClearField)

        defer {
            let data = attributeDictionary[attributeDescription.keys.first ?? ""]
            self.currentValue = data
        }

        self.attributeDescriptionString = attributeDescription.description
        self.textFieldPlaceholder = attributeDescription.placeholder
        self.handleDataAction = action
    }

//    init() {
//
////        super.init(actionForClearField: actionForClearField)
//
//        super.init(reuseIdentifier: "PickerInputViewCell")
//
////        defer {
////            let data = attributeDictionary[attributeDescription.keys.first ?? ""]
////            self.currentValue = data
////        }
////
////        self.attributeDescriptionString = attributeDescription.description
////        self.textFieldPlaceholder = attributeDescription.placeholder
////        self.handleDataAction = action
//
//        setupView()
//    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        return AccountantType.count
    }

    func pickerView(pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return AccountantType(index: row).description
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
