//
//  DateInputViewCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

struct DateInputViewCellFactory: AbstractFactory {

    var tableView: UITableView

    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.registerClass(
            DateInputViewCell.self,
            forCellReuseIdentifier: DateInputViewCell.reuseIdentifier)
    }

    mutating func createCustomTableViewCell(
        attributeDescription: EmployeeAttribute,
        employeeAttributeContainer: EmployeeAttributeContainer) -> CustomTableViewCell {

        guard let cell = self.tableView.dequeueReusableCellWithIdentifier(
            DateInputViewCell.reuseIdentifier) as? DateInputViewCell
        else {fatalError()}

        cell.updateUI(
            attributeDescription,
            valuesAttributeDictionary: employeeAttributeContainer.valuesDictionary,
            action: { (startDate, endDate) in
                let startDateKey = attributeDescription.keys[0]
                let endDateKey = attributeDescription.keys[1]
                employeeAttributeContainer.valuesDictionary[startDateKey] = startDate
                employeeAttributeContainer.valuesDictionary[endDateKey] = endDate
            },
            actionForClearField: {
                let startDateKey = attributeDescription.keys[0]
                let endDateKey = attributeDescription.keys[1]
                employeeAttributeContainer.valuesDictionary[startDateKey] = nil
                employeeAttributeContainer.valuesDictionary[endDateKey] = nil
        })
        return cell
    }
}
