//
//  EditingState.swift
//  TestApplication
//
//  Created by developer on 17.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

class EditingState: State {
    //MARK: Parameters
    typealias Owner = EmployeeDetailViewController
    var owner: Owner
    var copyOfEmployee: Employee?

    lazy private var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Cancel",
                               style: .Plain,
                               target: self,
                               action: #selector(cancelAction))
    }()

    lazy private var saveBarButtonItem: UIBarButtonItem = {
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
    func isEditing() -> Bool {return true}
    func isBrowsing() -> Bool {return false}
    func isCreating() -> Bool {return false}

    func setupNavigationItem() {
        owner.navigationItem.title = ""
        owner.navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    @objc func cancelAction() {
        owner.navigationController?.popViewControllerAnimated(true)
    }

    @objc func doneAction() {
        guard let editedEmployee = owner.employee
            else {return}

        let dataStack = owner.coreDataStack
        let valuesDictionary = owner.employeeAttributeContainer.valuesDictionary
        let finalEmployeeTypeName = owner.employeeAttributeContainer
                                                    .displayedEmployeeType
                                                    .description

        if finalEmployeeTypeName == editedEmployee.entity.name {
            editedEmployee.fillAttributes(valuesDictionary)
        } else {
            dataStack.mainQueueContext.deleteObject(editedEmployee)
            if let newEmployee = dataStack
                        .createEntityByName(finalEmployeeTypeName) as? Employee {
                newEmployee.fillAttributes(valuesDictionary)
                newEmployee.sectionOrder = owner.employeeAttributeContainer
                                                        .displayedEmployeeType
                                                        .orderIndex
            }
        }
        owner.coreDataStack.saveAndLog()
        owner.navigationController?.popViewControllerAnimated(true)
    }
}
