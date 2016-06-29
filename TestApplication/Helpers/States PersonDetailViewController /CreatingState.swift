//
//  CreatingState.swift
//  TestApplication
//
//  Created by developer on 17.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

class CreatingState: State {
    //MARK: Parameters
    typealias Owner = EmployeeDetailViewController
    var owner: Owner

    lazy private var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Cancel",
                               style: .Plain,
                               target: self,
                               action: #selector(cancelAction))
    }()

    lazy private var saveNewEmployeeBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .Save,
                               target: self,
                               action: #selector(doneAction))
    }()

    //MARK:-
    required init(contex: Owner) {
        self.owner = contex
        setupNavigationItem()
    }
    //MARK:-

    //MARK: Protocol functions
    func isCreating() -> Bool {return true}
    func isBrowsing() -> Bool {return false}
    func isEditing() -> Bool {return false}

    func setupNavigationItem() {
        owner.navigationItem.title = "New Employee"
        owner.navigationItem.rightBarButtonItem = saveNewEmployeeBarButton
        owner.navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    @objc func cancelAction() {
        owner.navigationController?.popViewControllerAnimated(true)
    }

    @objc func doneAction() {
        defer {
            owner.navigationController?.popViewControllerAnimated(true)
        }

        let valuesDictionary = owner.employeeAttributeContainer.valuesDictionary
        let displayedEmployeeType = owner.employeeAttributeContainer
                                                        .displayedEmployeeType

        if let newEmployee = owner.coreDataStack
                .createEntityByName(displayedEmployeeType.description) as? Employee {
            newEmployee.fillAttributes(valuesDictionary)
            newEmployee.sectionOrder = displayedEmployeeType.orderIndex
            owner.coreDataStack.saveAndLog()
        }
    }
}
