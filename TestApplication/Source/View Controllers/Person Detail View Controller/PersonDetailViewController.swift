//
//  PersonDetailViewController.swift
//  TestApplication
//
//  Created by developer on 12.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class PersonDetailViewController: UIViewController {

    //MARK: State
    private var state: State?

    func changeStateToEditing() {
        state =  EditingState(contex: self)
    }

    func changeStateToCreating() {
        state = CreatingState(contex: self)
    }

    func changeStateToBrowsing() {
        switch state?.isEditing() {
        case (true?):
            state?.doneAction()
        default:
            break
        }
        state = BrowsingState(contex: self)
    }
    //MARK: -

    //MARK: Parameters
    var managedObjectContext: NSManagedObjectContext!

    var person: Person?
    var currentDisplayedPersonType: EmployeeType {
        guard let type = EmployeeType(
            orderIndex: personTypeSegmentControl.selectedSegmentIndex)
        else {
            fatalError("Invalid selectedSegmentIndex (\(personTypeSegmentControl.selectedSegmentIndex)) for enum EmployeeType.init(_:)")
        }

        return type
    }
    //MARK: -
    //MARK: Lazy parameters

    private lazy var employeeAttributeCellFactory: CustomCellFactory = {
        return CustomCellFactory(tableView: self.customTableView)
    }()

    lazy var employeeAttributeContainer: EmployeeAttributeContainer = {
        let attributeContainer = EmployeeAttributeContainer(
            displayedPersonType: self.currentDisplayedPersonType,
            aPerson: self.person)

        attributeContainer.delegate = self
        return attributeContainer
    }()

    lazy var customTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        return table
    }()

    lazy var personTypeSegmentControl: UISegmentedControl = {

        let entityNames = [
            EmployeeType.Manager.description,
            EmployeeType.Worker.description,
            EmployeeType.Accountant.description
        ]
        let segment = UISegmentedControl(items: entityNames)

        if let person = self.person {
            segment.enabled = false
            self.changeStateToBrowsing()
        } else {
            self.changeStateToCreating()
        }

        let index = EmployeeType(aPerson: self.person)?.orderIndex

        switch index {
        case let (index?):
            segment.selectedSegmentIndex = index
        default:
            segment.selectedSegmentIndex = 0
        }

        segment.addTarget(self, action: #selector(segmentControlChangeValue),
                          forControlEvents: .ValueChanged)

        self.view.addSubview(segment)
        return segment
    }()
    //MARK: -

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupGestureRecognizer()
        checkValid()
    }

    //MARK: addTarget's functions
    @objc func segmentControlChangeValue(sender: UISegmentedControl) {
        employeeAttributeContainer.displayedPersonType = currentDisplayedPersonType
        self.customTableView.reloadData()
    }

    //MARK: Help functions

    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDoubleTap)
        )
        doubleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(doubleTap)
    }

    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        customTableView.endEditing(true)
    }

    func checkValid() {
        let filledAttributeKeys = employeeAttributeContainer
            .valuesDictionary
            .keys
        let allAttributeKeys = employeeAttributeContainer
            .displayedPersonType
            .attributeKeys
        var canTapSave = true
        for key in allAttributeKeys {
            if !filledAttributeKeys.contains(key) {
                canTapSave = false
            }
        }
        self.navigationItem.rightBarButtonItem?.enabled = canTapSave
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        customTableView.setEditing(editing, animated: animated)
        personTypeSegmentControl.enabled = editing

        if editing {
            changeStateToEditing()
        } else {
            changeStateToBrowsing()
        }
        customTableView.reloadData()
    }

    private func setupAoutoLayoutConstrains() {
        personTypeSegmentControl.snp_makeConstraints { (make) in
            make.top.centerX.equalTo(self.view).offset(8)
        }

        customTableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.personTypeSegmentControl.snp_bottom).offset(8)
            make.leading.trailing.bottom.equalTo(self.view)
        }
    }

    private func configureView() {
        setupAoutoLayoutConstrains()

        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.translucent = false
        self.customTableView.tableFooterView = UIView()
    }
}

//MARK: -
//MARK: Extension
//MARK: - EmployeeAttributeContainerDelegate

extension PersonDetailViewController: EmployeeAttributeContainerDelegate {
    func employeeAttributeContainerDidEnterData(
        container: EmployeeAttributeContainer) {
        checkValid()
    }
}

//MARK: - UITableViewDelegate
extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView,
                   editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }

    func tableView(tableView: UITableView,
                   willDisplayCell cell: UITableViewCell,
                                   forRowAtIndexPath indexPath: NSIndexPath) {

        switch state?.isBrowsing() {
        case (true?):
            cell.userInteractionEnabled = false
            cell.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        default:
            cell.userInteractionEnabled = true
            cell.backgroundColor = UIColor.whiteColor()
        }
    }

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return employeeAttributeContainer
                                .displayedPersonType
                                .numberDisplayedAttributes
    }

    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return employeeAttributeCellFactory.cellForAttribute(
            employeeAttributeContainer,
            attributeDescription: employeeAttributeContainer
                .attributeDescriptions[indexPath.row])
    }

    func tableView(tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Profile"
        default:
            fatalError("Unknown section")
        }
    }
}
