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

        self.navigationItem.title = "List"

        configureTableView()
        createUIBarButton()

        registrateNibForAllUsingCell()

        performFetch(self.fetchedResultsController)
    }

    //MARK: Working with TableView

    override func tableView(tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {

        guard
            let firstPersonInSection = fetchedResultsController.sections?[section].objects.first,
            let iconAndTitleName = firstPersonInSection.entity.name
        else {
            return nil
        }

        //Image name for entity = aPerson.entity.name
        return tableViewHeader(iconAndTitleName, imageName: iconAndTitleName)
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
        case let guidance as Guidance :

            if let guidanceCell = (tableView.dequeueReusableCellWithIdentifier(
                KeysForCells.guidanceTableViewCell, forIndexPath: indexPath)) as? GuidanceTableViewCell {
                configureGuidanceCell(guidanceCell, aGuidance: guidance)
                maybeCell = guidanceCell
            }

        case let bookkeeping as Bookkeeping:
            if let bookkeepingCell = (tableView.dequeueReusableCellWithIdentifier(
                KeysForCells.bookkeepingTableViewCell, forIndexPath: indexPath)) as? BookkeepingTableViewCell {
                configureBookkeepingCell(bookkeepingCell, aBookkeeping: bookkeeping)
                maybeCell = bookkeepingCell
            }

        case let staff as Staff:
            if let staffCell = (tableView.dequeueReusableCellWithIdentifier(
                KeysForCells.staffTableViewCell, forIndexPath: indexPath)) as? StaffTableViewCell {
                configureStaffCell(staffCell, aStaff: staff)
                maybeCell = staffCell
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

    private func tableViewHeader(title: String, imageName: String ) -> UITableViewHeaderFooterView {
        let header = UITableViewHeaderFooterView()

        let iconForSection = UIImageView()
        iconForSection.setImageWithoutCache(imageName)

        let sectionNameLabel = UILabel()
        sectionNameLabel.text = title

        header.addSubview(iconForSection)
        header.addSubview(sectionNameLabel)

        iconForSection.snp_makeConstraints {(make) -> Void in
            make.top.bottom.equalTo(header)
            make.width.equalTo(iconForSection.snp_height)
            make.leading.equalTo(header).offset(8)
        }

        sectionNameLabel.snp_makeConstraints {(make) -> Void in
            make.top.bottom.equalTo(header)
            make.left.equalTo(iconForSection.snp_right).offset(8)
        }
        return header
    }

    private func registrateNibForAllUsingCell () {
        tableView.registerNib(UINib(nibName: KeysForCells.guidanceTableViewCell, bundle: nil),
                              forCellReuseIdentifier: KeysForCells.guidanceTableViewCell)

        tableView.registerNib(UINib(nibName: KeysForCells.staffTableViewCell, bundle: nil),
                              forCellReuseIdentifier: KeysForCells.staffTableViewCell)

        tableView.registerNib(UINib(nibName: KeysForCells.bookkeepingTableViewCell, bundle: nil),
                              forCellReuseIdentifier: KeysForCells.bookkeepingTableViewCell)
    }

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 88
    }

    private func createUIBarButton() {
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

    private func configureStaffCell(cell: StaffTableViewCell, aStaff: Staff) {
        cell.fullNameLabel.text = aStaff.fullName
        cell.salaryLabel.text = aStaff.salary?.stringValue

        switch (aStaff.startMealTime?.timeFormat,
                aStaff.endMealTime?.timeFormat) {
        case let(fromTime?, toTime?):
            cell.mealTimeLabel.text = "From \(fromTime) to \(toTime)"
        default: break
        }

        cell.workplaeNumberLabel.text = aStaff.workplaceNumber?.stringValue
    }

    private func configureGuidanceCell(cell: GuidanceTableViewCell, aGuidance: Guidance) {
        cell.fullNameLabel.text = aGuidance.fullName
        cell.salaryLabel.text = aGuidance.salary?.stringValue

        switch (aGuidance.startVisitingHours?.timeFormat,
                aGuidance.endVisitingHours?.timeFormat) {
        case let (fromTime?, toTime?):
            cell.visitingHoursLabel.text = "From \(fromTime) to \(toTime)"
        default:
            break
        }
    }

    private func configureBookkeepingCell(cell: BookkeepingTableViewCell, aBookkeeping: Bookkeeping) {
        cell.fullNameLabel.text = aBookkeeping.fullName
        cell.salaryLabel.text = aBookkeeping.salary?.stringValue

        switch (aBookkeeping.startMealTime?.timeFormat,
                aBookkeeping.endMealTime?.timeFormat) {
        case let (fromTime?, toTime?):
            cell.mealTimeLabel.text = "From \(fromTime) to \(toTime)"
        default: break
        }
        
        cell.workplaeNumberLabel.text = aBookkeeping.workplaceNumber?.stringValue
        cell.bokkeepingTypeLabel.text = BookkeepingType(index: aBookkeeping.type?.integerValue ?? -1).description
    }
    
    //MARK: Structs
    struct KeysForCells {
        static let guidanceTableViewCell = "GuidanceTableViewCell"
        static let bookkeepingTableViewCell = "BookkeepingTableViewCell"
        static let staffTableViewCell = "StaffTableViewCell"
    }
}
