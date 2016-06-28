//
//  SimpleTextFieldCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

struct SimpleTextFieldCellFactory: AbstractFactory {

    var tableView: UITableView

    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.registerClass(
            SimpleTextFieldCell.self,
            forCellReuseIdentifier: SimpleTextFieldCell.reuseIdentifier)
    }

    mutating func createCustomTableViewCell(
        attributeDescription: EmployeeAttribute,
        employeeAttributeContainer: EmployeeAttributeContainer) -> CustomTableViewCell {

        guard let cell = self.tableView
            .dequeueReusableCellWithIdentifier(
                SimpleTextFieldCell.reuseIdentifier) as? SimpleTextFieldCell
        else {
            fatalError("cell with identifier \"\(SimpleTextFieldCell.reuseIdentifier)\" must be registered")
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
