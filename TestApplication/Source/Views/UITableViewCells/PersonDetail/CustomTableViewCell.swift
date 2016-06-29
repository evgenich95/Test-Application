//
//  CustomTableViewCell.swift
//  TestApplication
//
//  Created by developer on 12.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

class CustomTableViewCell: UITableViewCell {

    var actionForClearField: (() -> Void)?

    //MARK: Parameters
    var inputDataType: NSAttributeType? {
        willSet {
            if let type = newValue {
                dataTextField.keyboardType = appropriateKeyboardType(type)
            }
        }
    }

    var textFieldPlaceholder: String? {
        willSet {
            if let placeholder = newValue {
                self.dataTextField.placeholder = placeholder
            }
        }
    }

    var attributeDescriptionString: String? {
        willSet {
            if let description = newValue {
                self.descriptionLabel.text = description
            }
        }
    }

    var attributeValue: AnyObject? {
        willSet {
            guard let value = newValue
                else {
                    dataTextField.text = ""
                    return
            }
            if let text = value as? String {
                dataTextField.text = text
            }

            if let text = value as? NSNumber {
                dataTextField.text = text.stringValue
            }
            textFieldValueChange()
        }
    }
    var dataTextFieldInputView: UIView? {
        willSet {
            dataTextField.inputView = newValue
        }
    }

    //MARK: Lazy Parameters

    lazy private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.6
        label.textAlignment = .Right
        self.addSubview(label)
        return label
    }()

    lazy private var dataTextField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .Right
        textField.delegate = self
        textField.minimumFontSize = 7
        textField.returnKeyType = .Done
        let separatedView = UIView()
        separatedView.bounds.size = (CGSize(width: 2, height: 2))
        separatedView.backgroundColor = UIColor.grayColor()
        textField.inputAccessoryView = separatedView
        textField.addTarget(self,
                            action: #selector(textFieldValueChange),
                            forControlEvents: .EditingChanged)

        self.addSubview(textField)
        return textField
    }()

    //MARK:-

    func updateUI(inputDataType: NSAttributeType = .StringAttributeType,
                actionForClearField: () -> Void) {
        defer {
            self.inputDataType = inputDataType
        }
        self.actionForClearField = actionForClearField

    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: addTargert's functions

    @objc private func textFieldValueChange() {
        handleEnteringData(dataTextField)
        if dataTextField.text?.characters.count < 1 {
            actionForClearField?()
        }
    }

    func handleEnteringData(textField: UITextField) {
        fatalError("handleEnteringData must be implemet by subcluss")
    }

    //MARK: Help functions

    private func appropriateKeyboardType (inputDataType: NSAttributeType) -> UIKeyboardType {
        switch inputDataType {
        case .StringAttributeType:
            return UIKeyboardType.Default
        case .DecimalAttributeType,
             .DoubleAttributeType,
             .FloatAttributeType:
            return UIKeyboardType.DecimalPad
        case .Integer32AttributeType:
            return UIKeyboardType.NumberPad
        default:
            return UIKeyboardType.Default
        }
    }

    private func configureView() {
        descriptionLabel.snp_makeConstraints { (make) -> Void in
            make.leading.top.equalTo(self).offset(8)
            make.centerY.equalTo(self)
            // 40% from cell.width
            make.width.equalTo(self.snp_width).multipliedBy(0.4)
        }

        dataTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(8)
            make.trailing.equalTo(self).inset(8)
            make.centerY.equalTo(self)
            // 60% from cell.width
            make.left.equalTo(descriptionLabel.snp_right).offset(8)
        }
    }
}

//MARK:-
//MARK: Extensions
//MARK:-

extension CustomTableViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        guard let dataType = inputDataType
            else {return true}

        switch dataType {
        case .StringAttributeType:
            return true
        case .DateAttributeType:
            return false
        default:
            let aSet = NSCharacterSet(charactersInString:"0123456789.")
                .invertedSet
            let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
            let numberFiltered = compSepByCharInSet.joinWithSeparator("")
            return string == numberFiltered
        }
    }
}
