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
    typealias Owner = PersonDetailViewController
    var owner: Owner

    lazy private var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            title: "Cancel",
            style: .Plain,
            target: self,
            action: #selector(cancelAction))
    }()

    lazy private var saveNewPersonBarButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .Save,
            target: self,
            action: #selector(doneAction))
    }()

    //MARK:-
    required init(contex: Owner) {
        self.owner = contex
        setupNavigationItem()
        setupView()
    }
    //MARK:-

    //MARK: Protocol functions
    func isCreating() -> Bool {return true}
    func isBrowsing() -> Bool {return false}
    func isEditing() -> Bool {return false}

    func setupNavigationItem() {
        owner.navigationItem.title = "New Person"
        owner.navigationItem.rightBarButtonItem = saveNewPersonBarButton
        owner.navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    @objc func cancelAction() {
        if let person = owner.person {
            owner.coreDataStack.mainQueueContext.deleteObject(person)
        }
        doneAction()
    }
    @objc func doneAction() {
        owner.coreDataStack.saveAndLog()
        owner.navigationController?.popViewControllerAnimated(true)
    }

    //MARK: Help functions
    func setupView() {
        owner.checkValid()
        owner.customTableView.backgroundView?.hidden = false
    }
}
