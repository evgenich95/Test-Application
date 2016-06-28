//
//  CustomCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

struct CustomCellFactory {
    var tableView: UITableView

    private lazy var simpleTextFieldCellFactory: SimpleTextFieldCellFactory = {
        return SimpleTextFieldCellFactory(tableView: self.tableView)
    }()

    private lazy var pickerInputViewCellFactory: PickerInputViewCellFactory = {
        return PickerInputViewCellFactory(tableView: self.tableView)
    }()

    private lazy var dateInputViewCellFactory: DateInputViewCellFactory = {
        return DateInputViewCellFactory(tableView: self.tableView)
    }()

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    private mutating func appropriateFactory(
        attributeDescription: EmployeeAttribute) -> AbstractFactory {

        switch attributeDescription {
        case .FullName, .Salary, .WorkplaceNumber:
            return simpleTextFieldCellFactory
        case .AccountantType:
            return pickerInputViewCellFactory
        case .MealTime, .VisitingHours:
            return dateInputViewCellFactory
        }
    }

    mutating func cellForAttribute(
        employeeAttributeContainer: EmployeeAttributeContainer,
        attributeDescription: EmployeeAttribute)
        -> UITableViewCell {
            var factory = appropriateFactory(attributeDescription)
            return factory.createCustomTableViewCell(
                attributeDescription,
                employeeAttributeContainer: employeeAttributeContainer)
    }
}
