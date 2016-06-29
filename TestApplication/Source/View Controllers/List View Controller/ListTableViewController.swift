//
//  ListEmployeeTableViewController.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class ListEmployeeTableViewController: UITableViewController {

    //MARK: Parameters
    var coreDataStack: CoreDataStack!

    var userIsEditing = false

    lazy private var addButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: #selector(createNewEmployee)
        )
    }()

    lazy var fetchedResultsController: NSFetchedResultsController = {

        let fetchRequest = NSFetchRequest(entityName: Employee.entityName)

        let typeSortDescriptor = NSSortDescriptor(
            key: SortDescriptorKeys.SectionOrder,
            ascending: true)

        let nameSortDescriptor = NSSortDescriptor(
            key: SortDescriptorKeys.FullName,
            ascending: true)

        let orderSortDescriptor = NSSortDescriptor(
            key: SortDescriptorKeys.SectionElementOrder,
            ascending: false)

        fetchRequest.sortDescriptors = [typeSortDescriptor, orderSortDescriptor,
                                        nameSortDescriptor ]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.coreDataStack.mainQueueContext,
            sectionNameKeyPath: SortDescriptorKeys.SectionName,
            cacheName: nil)

        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: "ListEmployeeTableViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        guard let
            firstEmployeeInSection = fetchedResultsController
                                                .sections?[section]
                                                .objects?
                                                .first as? Employee,
            iconAndTitleName = firstEmployeeInSection.entity.name
            else {return nil}

        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier(
            KeysForCells.employeeTableViewHeader)
        if let header = cell as? EmployeeTableViewHeader {
            //sectionName == sectionIcon
            header.updateUI(iconAndTitleName, sectionIconName: iconAndTitleName)
        }
        return cell
    }

    override func tableView(
        tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == .Delete {
            if let record = fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject {
                coreDataStack.mainQueueContext.deleteObject(record)
                coreDataStack.saveAndLog()
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

        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var maybeCell: UITableViewCell?

        guard let employee = fetchedResultsController
                                    .sections?[indexPath.section]
                                    .objects?[indexPath.row]
            else {
                fatalError("aEmployee in \(indexPath) indexPath dosen't exist ")
        }

        switch employee {
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
            else {
                fatalError("Cell \(maybeCell) is not registered")
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        guard let employee = fetchedResultsController
                                    .sections?[indexPath.section]
                                    .objects?[indexPath.row] as? Employee
            else {
                fatalError("aEmployee in \(indexPath) indexPath dosen't exist ")
        }

        let createNewEmployeeViewController = EmployeeDetailViewController(
            coreDataStack: coreDataStack)

        createNewEmployeeViewController.employee = employee

        self.navigationController?.pushViewController(
            createNewEmployeeViewController,
            animated: true
        )
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

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

        if fromIndexPath == toIndexPath {
            return
        }

        userIsEditing = true

        if var employees = fetchedResultsController
                                .sections?[fromIndexPath.section]
                                .objects as? [Employee] {

            let employee = employees[fromIndexPath.row]
            employees.removeAtIndex(fromIndexPath.row)
            employees.insert(employee, atIndex: toIndexPath.row)

            var idx = employees.count
            for employee in employees {
                idx-=1
                employee.order = idx
            }

            coreDataStack.saveAndLog()
            userIsEditing = false
        }
    }

    //MARK: AddTarget's functions

    @objc func createNewEmployee() {
        let createNewEmployeeViewController = EmployeeDetailViewController(coreDataStack: coreDataStack)
        self.navigationController?.pushViewController(createNewEmployeeViewController, animated: true)
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
        tableView.registerClass(EmployeeTableViewHeader.self,
                                forHeaderFooterViewReuseIdentifier: KeysForCells.employeeTableViewHeader)

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
    }

    //MARK: Structs
    private struct KeysForCells {
        static let managerTableViewCell = "ManagerTableViewCell"
        static let accountantTableViewCell = "AccountantTableViewCell"
        static let workerTableViewCell = "WorkerTableViewCell"
        static let employeeTableViewHeader = "EmployeeTableViewHeader"
    }

    private struct SortDescriptorKeys {
        static let FullName = "fullName"
        static let SectionElementOrder = "order"
        static let SectionOrder = "sectionOrder"
        static let SectionName = "sectionName"
    }
}

extension ListEmployeeTableViewController : NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        if userIsEditing {return}
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if userIsEditing {return}
        tableView.endUpdates()
    }

    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                    atIndexPath indexPath: NSIndexPath?,
                    forChangeType type: NSFetchedResultsChangeType,
                    newIndexPath: NSIndexPath?) {

        if userIsEditing {return}
        switch type {
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

    func controller(controller: NSFetchedResultsController,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                    atIndex sectionIndex: Int,
                    forChangeType type: NSFetchedResultsChangeType) {

        if userIsEditing {return}
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
