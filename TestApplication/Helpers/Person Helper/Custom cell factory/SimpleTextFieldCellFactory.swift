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
        personAttributeContainer: PersonAttributeContainer) -> CustomTableViewCell {

        guard let cell = self.tableView
            .dequeueReusableCellWithIdentifier(
                SimpleTextFieldCell.reuseIdentifier) as? SimpleTextFieldCell
        else {fatalError()}

        cell.updateUI(
            attributeDescription,
            valuesAttributeDictionary: personAttributeContainer.valuesDictionary,
            action: { (data) in
                let key = attributeDescription.keys.first ?? ""
                personAttributeContainer.valuesDictionary[key] = data
            },
            actionForClearField: {
                let key = attributeDescription.keys.first ?? ""
                personAttributeContainer.valuesDictionary[key] = nil
        })
        return cell
    }
}
