//
//  EditingState.swift
//  TestApplication
//
//  Created by developer on 17.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditingState: State {
    //MARK: Parameters
    typealias Owner = PersonDetailViewController
    var owner: Owner
    var copyOfPerson: Person?

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
        guard let editedPerson = owner.person
            else {return}

        let context = owner.managedObjectContext
        let valuesDictionary = owner.employeeAttributeContainer.valuesDictionary
        let finalPersonTypeName = owner.employeeAttributeContainer
                                                    .displayedPersonType
                                                    .description

        if finalPersonTypeName == editedPerson.entity.name {
            editedPerson.fillAttributes(valuesDictionary)
        } else {
            context.deleteObject(editedPerson)
            if let newPerson = createEntityByName(finalPersonTypeName,managesContext: context) as? Person {
                newPerson.fillAttributes(valuesDictionary)
            }
        }
        do {
            try context.save()
        } catch {
            NSLog("\(error)")
        }
        owner.navigationController?.popViewControllerAnimated(true)
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
