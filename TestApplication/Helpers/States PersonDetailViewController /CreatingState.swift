//
//  CreatingState.swift
//  TestApplication
//
//  Created by developer on 17.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CreatingState: State {
    //MARK: Parameters
    typealias Owner = PersonDetailViewController
    var owner: Owner

    lazy private var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Cancel",
                               style: .Plain,
                               target: self,
                               action: #selector(cancelAction))
    }()

    lazy private var saveNewPersonBarButton: UIBarButtonItem = {
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
        owner.navigationItem.title = "New Person"
        owner.navigationItem.rightBarButtonItem = saveNewPersonBarButton
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
        let entityName = owner.employeeAttributeContainer.displayedPersonType
                                                                .description

        if let newPerson = createEntityByName(entityName, managesContext: owner.managedObjectContext) as? Person {
            newPerson.fillAttributes(valuesDictionary)
            do {
                try owner.managedObjectContext.save()
            } catch {
                NSLog("\(error)")
            }

        }
    }

    func createEntityByName(entityName: String, managesContext: NSManagedObjectContext) -> NSManagedObject {
        guard let description = NSEntityDescription
            .entityForName(entityName,
                           inManagedObjectContext: managesContext)
            else {
                fatalError("Could not create an entity with the given name: \"\(entityName)\"")
        }

        return NSManagedObject
            .init(entity: description,
                  insertIntoManagedObjectContext: managesContext)
    }
}
