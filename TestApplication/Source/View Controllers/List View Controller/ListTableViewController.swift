//
//  ListPersonTableViewController.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class ListPersonTableViewController: UITableViewController {

    //MARK: Parameters
    var managedObjectContext: NSManagedObjectContext!

    lazy private var addButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: #selector(createNewPerson)
        )
    }()
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: Person.entityName)

        // Add Sort Descriptors

        let nameSortDescriptor = NSSortDescriptor(key: "fullName",
                                                  ascending:  true)
        let typeSortDescriptor = NSSortDescriptor(key: "entity.name",
                                                  ascending:  true)
        let orderSortDescriptor = NSSortDescriptor(key: "order",
                                                   ascending:  false)

        fetchRequest.sortDescriptors = [typeSortDescriptor, orderSortDescriptor,
                                        nameSortDescriptor ]

        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: "entity.name", cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

//    lazy private var fetchedResultsController: FetchedResultsController<Person> = {
//        let fetchRequest = NSFetchRequest(entityName: Person.entityName)
//
//        let nameSortDescriptor = NSSortDescriptor(key: "fullName",
//                                                  ascending:  true)
//        let typeSortDescriptor = NSSortDescriptor(key: "entity.name",
//                                                  ascending:  true)
//        let orderSortDescriptor = NSSortDescriptor(key: "order",
//                                                   ascending:  false)
//
//        fetchRequest.sortDescriptors = [typeSortDescriptor, orderSortDescriptor,
//                                        nameSortDescriptor ]
//
//        let frc = FetchedResultsController<Person>(
//            fetchRequest: fetchRequest,
//            managedObjectContext: self.coreDataStack.mainQueueContext,
//            sectionNameKeyPath: "entity.name")
//
//        frc.setDelegate(self.frcDelegate)
//        return frc
//    }()

//    lazy private var frcDelegate: PersonsFetchedResultsControllerDelegate = {
//        return PersonsFetchedResultsControllerDelegate(tableView: self.tableView)
//    }()
    //MARK:-


//    private var fetchedResultsController: NSFetchedResultsController? {
//        didSet {
//            do {
//                try fetchedResultsController?.performFetch()
//            } catch {
//                print("Failed to fetch objects: \(error)")
//            }
//            tableView?.reloadData()
//        }
//    }


    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init(nibName: "ListPersonTableViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
//        performFetch()
//        super.viewDidAppear(animated)
//        tableView.reloadData()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        setupNavigationItems()
        registrateAllUsingCell()
        performFetch()
    }



    //MARK: Working with TableView

    override func tableView(tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
//        guard let
//            firstPersonInSection = fetchedResultsController
//                                                .sections?[section]
//                                                .objects!.first,
//            iconAndTitleName = firstPersonInSection.entity.name
//        else {return nil}

        guard let sections = fetchedResultsController
            .sections?[section]
            else { fatalError() }

        guard let firstPersonInSection = sections.objects?.first as? Person,
            iconAndTitleName = firstPersonInSection.entity.name

            else {
                return nil
        }


        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier(
            KeysForCells.personTableViewHeader)
        if let header = cell as? PersonTableViewHeader {
            //sectionName == sectionIcon
            header.updateUI(iconAndTitleName, sectionIconName: iconAndTitleName)
        }
        return cell
    }

    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {

//        if editingStyle == .Delete {
//            if let person = fetchedResultsController
//                                            .sections?[indexPath.section]
//                                            .objects![indexPath.row] {
//                self.managedObjectContext.deleteObject(person as! NSManagedObject)
//            }
//        }
        if editingStyle == .Delete {
            if let record = fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject {
                record.delete()
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        defer {
            updateEditButtonItemStatus()
        }
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }

    override func tableView(tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {

//        if let sections = fetchedResultsController.sections {
//            let currentSection = sections[section]
//            return currentSection.objects!.count
//        }
//        return 0

        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }

        return 0
    }

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var maybeCell: UITableViewCell?

        guard let sections = fetchedResultsController
                                    .sections?[indexPath.section]
            else { fatalError("Don't have aPerson for \(indexPath) indexPath ") }

        guard let person = sections.objects?[indexPath.row]
        else {
            fatalError()
        }

        switch person {
        case let manager as Manager :

            if let managerCell = (tableView.dequeueReusableCellWithIdentifier(
                KeysForCells.managerTableViewCell,
                forIndexPath: indexPath)) as? ManagerTableViewCell {

                managerCell.updateUI(manager)
                maybeCell = managerCell
            }

        case let accountant as Accountant:
            if let accountantCell = (tableView.dequeueReusableCellWithIdentifier(
                KeysForCells.accountantTableViewCell,
                forIndexPath: indexPath)) as? AccountantTableViewCell {

                accountantCell.updateUI(accountant)
                maybeCell = accountantCell
            }

        case let worker as Worker:
            if let workerCell = (tableView.dequeueReusableCellWithIdentifier(
                KeysForCells.workerTableViewCell,
                forIndexPath: indexPath)) as? WorkerTableViewCell {

                workerCell.updateUI(worker)
                maybeCell = workerCell
            }
        default: break
        }

        guard let cell = maybeCell
            else { fatalError("Cell \(maybeCell) is not registered") }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        guard let sections = fetchedResultsController
            .sections?[indexPath.section]
            else { fatalError("Don't have aPerson for \(indexPath) indexPath ") }

        if  let person = sections.objects?[indexPath.row] as? Person {

            let createNewPersonViewController = PersonDetailViewController(
                managedObjectContext: managedObjectContext)

            createNewPersonViewController.person = person

            self.navigationController?.pushViewController(
                createNewPersonViewController,
                animated: true
            )
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.selected = false
        }
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(
        tableView: UITableView,
        targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath,
        toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {

        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }

//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//        if fromIndexPath == toIndexPath {
//            return
//        }
//
//        //disable auto updating tableView
//        //need to avoid error "invalid number of rows in section"
//        frcDelegate.userIsEditing = true
//
//        if var persons = fetchedResultsController
//                            .sections?[fromIndexPath.section]
//                            .objects {
//            let person = persons[fromIndexPath.row] as! Person
//
//            persons.removeAtIndex(fromIndexPath.row)
//            persons.insert(person, atIndex: toIndexPath.row)
//
//            var idx = persons.count
//            for person in persons {
//                idx-=1
//                person.order = idx
//            }
//
//            //need to save order of sections after reording elements
////            coreDataStack.saveAndLog()
//            do {
//                try self.managedObjectContext.save()
//            } catch {
//                NSLog("\(error)")
//            }
//
//            frcDelegate.userIsEditing = false
//            performFetch()
//        }
//    }

    //MARK: AddTarget's functions

    @objc func createNewPerson() {
        let createNewPersonViewController = PersonDetailViewController(managedObjectContext: managedObjectContext)
        self.navigationController?.pushViewController(createNewPersonViewController, animated: true)
    }

    @objc func editOrderOfList() {
        self.editing = !self.editing
    }

    //MARK: Help functions

    private func updateEditButtonItemStatus() {

        self.editButtonItem().enabled = true

        if fetchedResultsController.fetchedObjects?.count == 0 {
            self.setEditing(false, animated: true)
            self.editButtonItem().enabled = false
        }
    }

    private func registrateAllUsingCell () {
        tableView.registerClass(PersonTableViewHeader.self,
                                forHeaderFooterViewReuseIdentifier: KeysForCells.personTableViewHeader)

        tableView.registerNib(UINib(nibName: KeysForCells.managerTableViewCell, bundle: nil),
                              forCellReuseIdentifier: KeysForCells.managerTableViewCell)

        tableView.registerNib(UINib(nibName: KeysForCells.workerTableViewCell, bundle: nil),
                              forCellReuseIdentifier: KeysForCells.workerTableViewCell)

        tableView.registerNib(UINib(nibName: KeysForCells.accountantTableViewCell, bundle: nil),
                              forCellReuseIdentifier: KeysForCells.accountantTableViewCell)
    }

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 190
        tableView.sectionHeaderHeight = 40
    }

    private func setupNavigationItems() {
        self.navigationItem.title = "List"
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
//        tableView.reloadData()
    }

    //MARK: Structs
    struct KeysForCells {
        static let managerTableViewCell = "ManagerTableViewCell"
        static let accountantTableViewCell = "AccountantTableViewCell"
        static let workerTableViewCell = "WorkerTableViewCell"
        static let personTableViewHeader = "PersonTableViewHeader"
    }
}

extension ListPersonTableViewController : NSFetchedResultsControllerDelegate {

    // swiftlint:disable control_statement
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject,
                    atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }

        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }

        case .Update:
            if let indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }

        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }

            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }

        }
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {

        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
    }

}

extension NSManagedObject {
    func delete () {
        self.managedObjectContext?.deleteObject(self)

        do {
            // Save Record
            try self.managedObjectContext?.save()
            print("All are saved")

        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")


            print("Your to-do could not be saved.")
        }
        
    }
}

