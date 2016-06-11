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
    typealias ResultDataActionType = ((startDate: NSDate, endDate: NSDate)
        -> Void)?
    var handleDataAction: ResultDataActionType
    var filedPickers = [Int: UIDatePicker]()

    //MARK: -
    //MARK: Lazy parameters

    lazy private var startTimeDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.grayColor()
        datePicker.datePickerMode = UIDatePickerMode.Time
        datePicker.locale = NSLocale(localeIdentifier: "en_GB")
        datePicker.addTarget(self,
                             action: #selector(datePickerValueChange),
                             forControlEvents: .ValueChanged)
        return datePicker
    }()

    lazy private var endTimeDatePicker: UIDatePicker = {

        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.grayColor()
        datePicker.datePickerMode = UIDatePickerMode.Time
        datePicker.locale = NSLocale(localeIdentifier: "en_GB")
        datePicker.addTarget(self,
                             action: #selector(datePickerValueChange),
                             forControlEvents: .ValueChanged)
        return datePicker
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

    init(attributeDescription: PersonAttributeDescription,
         attributeDictionary: [String : AnyObject],
         action: ResultDataActionType,
         actionForClearField: () -> Void) {

        super.init(actionForClearField: actionForClearField)
        defer {
            if
                let startDate = attributeDictionary[attributeDescription.key[0]]
                    as? NSDate,
                let endDate = attributeDictionary[attributeDescription.key[1]]
                    as? NSDate {
                self.startTimeDatePicker.setDate(startDate, animated: false)
                self.endTimeDatePicker.setDate(endDate, animated: false)
                updateDateValue()
            }
        }

        self.attributeDescriptionString = attributeDescription.description
        self.textFieldPlaceholder = attributeDescription.placeholder
        self.handleDataAction = action

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: AddTarget's functions
    @objc func datePickerValueChange(sender: UIDatePicker) {
        var direction: Double = 1
        switch sender {
        case startTimeDatePicker :
            startTimeDatePicker.backgroundColor = UIColor.whiteColor()

        case endTimeDatePicker:
            endTimeDatePicker.backgroundColor = UIColor.whiteColor()
            direction *= -1
        default:
            break
        }

        if startTime.compare(endTime) == NSComparisonResult.OrderedDescending {
            print("moved endTime")
            print("interval startTime to endTime = \(-1*startTime.timeIntervalSinceDate(endTime))")
            let interval = startTime.timeIntervalSinceDate(endTime)
            self.startTimeDatePicker.setDate(startTime.dateByAddingTimeInterval(-1*(interval+60*30)), animated: true)
        }



    }

    override func handleEnteringData(textField: UITextField) {
        print("DateInputViewCell.handleEnteringData()")

        handleDataAction?(startDate: startTimeDatePicker.date, endDate: endTimeDatePicker.date)
    }
//    override func textFieldDidEndEditing(textField: UITextField) {
//        super.textFieldDidEndEditing(textField)
//        switch (startTime, endTime) {
//        case let (startTime?, endTime?):
//            handleDataAction?(startDate: startTime, endDate: endTime)
//        default:
//            break
//        }
//    }

    //MARK: Help functions

        default:
            break
        }
    }

    func updateDateValue() {
        if filedPickers.count == 2 {
            attributeValue = "from \(startTimeDatePicker.date.timeFormating) to \(endTimeDatePicker.date.timeFormating)"
        }
    }
    
    func setupView() {
        dataTextFieldInputView = self.dateInputView
    }
}
