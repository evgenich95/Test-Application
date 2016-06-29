//
//  BrowsingState.swift
//  TestApplication
//
//  Created by developer on 17.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

class BrowsingState: State {
    //MARK: Parameters
    typealias Owner = EmployeeDetailViewController
    var owner: Owner

    lazy private var backBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            title: "Back",
            style: .Plain,
            target: self,
            action: #selector(cancelAction))
    }()
    //MARK:-

    required init(contex: Owner) {
        self.owner = contex
        setupNavigationItem()
    }
    //MARK:-

    //Protocol functions

    func isBrowsing() -> Bool {return true}
    func isEditing() -> Bool {return false}
    func isCreating() -> Bool {return false}

    func setupNavigationItem() {
        owner.navigationItem.title = owner.employee?.fullName
        owner.navigationItem.rightBarButtonItem = owner.editButtonItem()
        owner.navigationItem.leftBarButtonItem = backBarButtonItem
    }

    @objc func cancelAction() {
        owner.navigationController?.popViewControllerAnimated(true)
    }

    @objc func doneAction() {
    }
}
