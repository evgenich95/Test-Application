//
//  DateInputViewCell.swift
//  TestApplication
//
//  Created by developer on 13.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class DateInputViewCell: CustomTableViewCell {

    //MARK: Parameters
    static let reuseIdentifier = "DateInputViewCell"
    typealias ResultDataActionType = ((startDate: NSDate, endDate: NSDate) -> Void)
    var handleDataAction: ResultDataActionType?

    //MARK: -
    //MARK: Lazy parameters
    private var customTimePicker: UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.grayColor()
        datePicker.datePickerMode = UIDatePickerMode.Time
        datePicker.locale = NSLocale(localeIdentifier: "en_GB")
        datePicker.addTarget(self,
                             action: #selector(datePickerValueChange),
                             forControlEvents: .ValueChanged)

        return datePicker
    }

    lazy private var startTimeDatePicker: UIDatePicker = {
        return self.customTimePicker
    }()

    lazy private var endTimeDatePicker: UIDatePicker = {
        return self.customTimePicker
    }()

    lazy private var dateInputView: UIView = {
        let view = UIView(frame: CGRect(
            x: 0, y: 0,
            width: self.bounds.width,
            height: 200))
        view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)

        let startLable = UILabel()
        startLable.text = "Start Time"

        let endLabel = UILabel()
        endLabel.text = "End Time"

        view.addSubview(self.startTimeDatePicker)
        view.addSubview(self.endTimeDatePicker)
        view.addSubview(startLable)
        view.addSubview(endLabel)

        startLable.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.centerX.equalTo(self.startTimeDatePicker)
        }

        endLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.centerX.equalTo(self.endTimeDatePicker)
        }

        self.startTimeDatePicker.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view)
            make.top.equalTo(startLable.snp_bottom)
            make.width.equalTo(view).dividedBy(2)
        }

        self.endTimeDatePicker.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(view)
            make.top.equalTo(endLabel.snp_bottom)
            make.width.equalTo(view).dividedBy(2)
        }
        return view
    }()

    //MARK: -


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        attributeValue = nil
    }

    //MARK: AddTarget's functions
    @objc func datePickerValueChange(sender: UIDatePicker) {
        startTimeDatePicker.backgroundColor = UIColor.whiteColor()
        endTimeDatePicker.backgroundColor = UIColor.whiteColor()

        chekValidAfterInteredData(sender)
        updateTextFieldValue()
    }

    override func handleEnteringData(textField: UITextField) {
        handleDataAction?(startDate: startTimeDatePicker.date, endDate: endTimeDatePicker.date)
    }

    //MARK: Help functions
    func updateUI(attributeDescription: EmployeeAttribute,
                  valuesAttributeDictionary: [String : AnyObject],
                  action: ResultDataActionType,
                  actionForClearField: () -> Void) {

        super.updateUI(attributeDescription.type,
                       actionForClearField: actionForClearField)

        self.attributeDescriptionString = attributeDescription.description
        self.textFieldPlaceholder = attributeDescription.placeholder
        self.handleDataAction = action

        if  let startDate = valuesAttributeDictionary[attributeDescription.keys[0]]
            as? NSDate,
            endDate = valuesAttributeDictionary[attributeDescription.keys[1]]
                as? NSDate {
            self.startTimeDatePicker.setDate(startDate, animated: false)
            self.endTimeDatePicker.setDate(endDate, animated: false)
            updateTextFieldValue()
        }
    }


    func updateTextFieldValue() {
        attributeValue = "from \(startTimeDatePicker.date.timeString) to \(endTimeDatePicker.date.timeString)"
    }

    func chekValidAfterInteredData(inDatePicker: UIDatePicker) {
        if startTimeDatePicker.date.compare(endTimeDatePicker.date) == NSComparisonResult.OrderedDescending {

            var needChangePicker = UIDatePicker()
            var setDate = NSDate()

            switch inDatePicker {
            case startTimeDatePicker:
                needChangePicker = endTimeDatePicker
                setDate = startTimeDatePicker.date.byAddingMinutes(30)
            case endTimeDatePicker:
                needChangePicker = startTimeDatePicker
                setDate = endTimeDatePicker.date.bySubtractingMinutes(30)
            default:
                break
            }
            needChangePicker.setDate(setDate, animated: true)
        }
    }

    func setupView() {
        dataTextFieldInputView = self.dateInputView
    }
}
