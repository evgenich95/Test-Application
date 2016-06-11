//
//  ListPersonTableViewController.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack
import SnapKit

class ListPersonTableViewController: UITableViewController {

    //MARK: Parameters
    var coreDataStack: CoreDataStack!

    lazy private var addButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: #selector(addNewPerson)
        )
    }()

    lazy private var fetchedResultsController: FetchedResultsController<Person> = {
        let fetchRequest = NSFetchRequest(entityName: Person.entityName)

        let nameSortDescriptor = NSSortDescriptor(key: "fullName", ascending:  true)
        let typeSortDescriptor = NSSortDescriptor(key: "entity.name", ascending:  true)
        let orderSortDescriptor = NSSortDescriptor(key: "order", ascending:  false)

        fetchRequest.sortDescriptors = [typeSortDescriptor, orderSortDescriptor,
                                        nameSortDescriptor ]

        let frc = FetchedResultsController<Person>(
            fetchRequest: fetchRequest,
            managedObjectContext: self.coreDataStack.mainQueueContext,
            sectionNameKeyPath: "entity.name")

        frc.setDelegate(self.frcDelegate)
        return frc
    }()

    lazy private var frcDelegate: PersonsFetchedResultsControllerDelegate = {
        return PersonsFetchedResultsControllerDelegate(tableView: self.tableView)
    }()
    //MARK:-

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: "ListPersonTableViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        //включаю наблюдатель и обновляю модель
        //после возможных изменений в PersonDetailController-e
        frcDelegate.tableView = self.tableView
        performFetch(fetchedResultsController)

        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        setupNavigationItems()
        registrateAllUsingCell()
        performFetch(self.fetchedResultsController)
    }

    //MARK: Working with TableView

    override func tableView(tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        guard
            let firstPersonInSection = fetchedResultsController.sections?[section].objects.first,
            let iconAndTitleName = firstPersonInSection.entity.name
        else {return nil}

        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier(
            KeysForCells.personTableViewHeader)
        if let header = cell as? PersonTableViewHeader {
            //sectionName = sectionIcon
            header.updateUI(iconAndTitleName, sectionIconName: iconAndTitleName)
        }
        return cell
    }

    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == .Delete {
            if let person = fetchedResultsController.sections?[indexPath.section].objects[indexPath.row] {
                self.coreDataStack.mainQueueContext.deleteObject(person)
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.objects.count
        }

        return 0
    }

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var maybeCell: UITableViewCell?

        guard let person = fetchedResultsController.sections?[indexPath.section].objects[indexPath.row]
            else { fatalError("Don't have aPerson for \(indexPath) indexPath ") }

        switch person {
        case let manager as Manager :

            if let managerCell = (tableView.dequeueReusableCellWithIdentifier(
                KeysForCells.managerTableViewCell, forIndexPath: indexPath)) as? ManagerTableViewCell {
                managerCell.updateUI(manager)
                maybeCell = managerCell
            }

        case let accountant as Accountant:
            if let accountantCell = (tableView.dequeueReusableCellWithIdentifier(
                KeysForCells.accountantTableViewCell, forIndexPath: indexPath)) as? AccountantTableViewCell {
                accountantCell.updateUI(accountant)
                maybeCell = accountantCell
            }

        case let worker as Worker:
            if let workerCell = (tableView.dequeueReusableCellWithIdentifier(
                KeysForCells.workerTableViewCell, forIndexPath: indexPath)) as? WorkerTableViewCell {
                workerCell.updateUI(worker)
                maybeCell = workerCell
            }

        default: break
        }

        guard let cell = maybeCell
            else { fatalError("Cell is not registered") }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //отписываюсь от автоматических обновлений
        frcDelegate.tableView = nil

        if let person = fetchedResultsController.sections?[indexPath.section].objects[indexPath.row] {

            let addNewPersonViewController = PersonDetailViewController(coreDataStack: coreDataStack)
            addNewPersonViewController.person = person

            self.navigationController?.pushViewController(addNewPersonViewController, animated: true)
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

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

        //нет смысла обновлять БД при равных позициях
        if fromIndexPath == toIndexPath {
            return
        }

        //отписываюсь от автом. обновления tableView
        frcDelegate.tableView = nil

        if var persons = self.fetchedResultsController.sections?[fromIndexPath.section].objects {
            let person = persons[fromIndexPath.row] as Person

            persons.removeAtIndex(fromIndexPath.row)
            persons.insert(person, atIndex: toIndexPath.row)

            var idx = persons.count
            for person in persons {
                idx-=1
                person.order = idx
            }

            coreDataStack.saveAndLog()

            //надо обновить данные fetchedResultsController, иначе порядок элементов не изменится
            frcDelegate.tableView = self.tableView
            performFetch(fetchedResultsController)
        }
    }

    //MARK: AddTarget's functions

    @objc func addNewPerson() {

        //отписываюсь от автообновлений, чтобы не было конфликтов
        //связанных с обновлением секций при добавлений и удалений
        frcDelegate.tableView = nil

        let addNewPersonViewController = PersonDetailViewController(coreDataStack: coreDataStack)
        self.navigationController?.pushViewController(addNewPersonViewController, animated: true)
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
        tableView.registerClass(PersonTableViewHeader.self, forHeaderFooterViewReuseIdentifier: KeysForCells.personTableViewHeader)

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

    private func performFetch(fetchedResultsController: FetchedResultsController<Person>) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }

    //MARK: Structs
    struct KeysForCells {
        static let managerTableViewCell = "ManagerTableViewCell"
        static let accountantTableViewCell = "AccountantTableViewCell"
        static let workerTableViewCell = "WorkerTableViewCell"
        static let personTableViewHeader = "PersonTableViewHeader"
    }
}
