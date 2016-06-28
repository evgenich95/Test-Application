//
//  PickerInputViewCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

struct PickerInputViewCellFactory: AbstractFactory {

    var tableView: UITableView

    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.registerClass(
            PickerInputViewCell.self,
            forCellReuseIdentifier: PickerInputViewCell.reuseIdentifier)
    }

    mutating func createCustomTableViewCell(
        attributeDescription: EmployeeAttribute,
        employeeAttributeContainer: EmployeeAttributeContainer) -> CustomTableViewCell {

        guard let cell = self.tableView
            .dequeueReusableCellWithIdentifier(
                PickerInputViewCell.reuseIdentifier) as? PickerInputViewCell
        else {
            fatalError("cell with identifier \"\(PickerInputViewCell.reuseIdentifier)\" must be registered")
        }

        cell.updateUI(
            attributeDescription,
            valuesAttributeDictionary: employeeAttributeContainer.valuesDictionary,
            action: { (data) in
                let key = attributeDescription.keys.first ?? ""
                employeeAttributeContainer.valuesDictionary[key] = data
            },
            actionForClearField: {
                let key = attributeDescription.keys.first ?? ""
                employeeAttributeContainer.valuesDictionary[key] = nil
        })
        return cell
    }
}
