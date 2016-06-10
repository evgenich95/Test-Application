//
//  PersonDetailViewController.swift
//  TestApplication
//
//  Created by developer on 12.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import SnapKit
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
    var person: Person?
    var coreDataStack: CoreDataStack!

    var selectedPersonType: Int? {
        willSet {
            print("Изменился тип Person,selectedPersonType.willSet()")

            guard
                let currentOrderIndex = newValue,
                let currentDisplayedPersonType = PersonTypeRecognizer(
                    orderIndex: currentOrderIndex)
            else { return }

            personAttributeDictionary?.displayedPersonType = currentDisplayedPersonType

            print("attributeDescriptions = \n\(personAttributeDictionary?.attributeDescriptions)")
            print("displayedPersonType = \(personAttributeDictionary?.displayedPersonType)")

            if let attributeDictionary = personAttributeDictionary {
                print("Пересоздал массив ячеек")
                customCells = CustomCellFactory.cellsFor(attributeDictionary)
            }
            print("customCells.count=\(customCells.count)")
            print("-------------------------\n")
        }
    }

    typealias AttributeDictionary = [String: AnyObject]

    var personAttributeDictionary: PersonAttributeDictionary?
    var customCells = [UITableViewCell]()

//    var currentDisplayedPersonType: PersonTypeRecognizer? {
//        let displayedTypeOrderIndex = self.personTypeSegmentControl.selectedSegmentIndex
//        return PersonTypeRecognizer(orderIndex: displayedTypeOrderIndex)
//    }

    var arrayOfFilledAttributes = [String]()

    //MARK: -
    //MARK: Lazy parameters

    lazy var customTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        return table
    }()

    lazy var personTypeSegmentControl: UISegmentedControl = {
        print("Создаю personTypeSegmentControl")
        defer {
            self.selectedPersonType = segment.selectedSegmentIndex
        }

        let entityNames = [
            PersonTypeRecognizer.ManagerType.description,
            PersonTypeRecognizer.WorkerType.description,
            PersonTypeRecognizer.AccountantType.description
        ]
        let segment = UISegmentedControl(items: entityNames)

        if let person = self.person {
//            self.personAttributeDictionary = person.attributeDictionary
            segment.enabled = self.editing
            self.changeStateToBrowsing()
        } else {
            self.changeStateToCreating()
        }

        let index = PersonTypeRecognizer(aPerson: self.person)?.orderIndex

        switch index {
        case let (index?):
            segment.selectedSegmentIndex = index
        default:
            segment.selectedSegmentIndex = 0
        }

        segment.addTarget(self, action: #selector(segmentControlChangeValue), forControlEvents: .ValueChanged)

        self.view.addSubview(segment)
        return segment
    }()
    //MARK: -
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\nviewDidLoad()")

        configureView()
        setupGestureRecognizer()
        guard
            let orderIndex = selectedPersonType,
            let displayedPersonType = PersonTypeRecognizer(orderIndex: orderIndex)
            else { return }

        print("Инициализировал personAttributeDictionary ")
        personAttributeDictionary = PersonAttributeDictionary(
            displayedPersonType: displayedPersonType,
            aPerson: person)
        personAttributeDictionary?.delegate = self

        print("attributeDescriptions = \n\(personAttributeDictionary?.attributeDescriptions)")
        print("displayedPersonType = \(personAttributeDictionary?.displayedPersonType)")

        if let attributeDictionary = personAttributeDictionary {
            print("Создал первый раз массив ячеек")
            customCells = CustomCellFactory.cellsFor(attributeDictionary)
        }
        print("customCells.count=\(customCells.count)")

        checkValid()
        print("-------------------------------\n")


//        let displayedTypeOrderIndex = personTypeSegmentControl.selectedSegmentIndex
//        currentDisplayedPersonType = PersonTypeRecognizer(
//            orderIndex: displayedTypeOrderIndex)

//        customCells = CustomCellFactory.cellsFor(
//            currentDisplayedPersonType,
//            attributeDictionary: personAttributeDictionary
//        )
    }

    //MARK: addTarget's functions
    @objc func segmentControlChangeValue(sender: UISegmentedControl) {


        selectedPersonType = personTypeSegmentControl.selectedSegmentIndex
//        checkValid()

//        guard let currentDisplayedPersonType = self.currentDisplayedPersonType
//            else {
//                fatalError("currentDisplayedPersonType must be created")
//        }
//        print("\n Before changingType")
//        print("\tpersonAttributeDictionary.count\(personAttributeDictionary.count)")
//        var newPersonAttributeDictionary = AttributeDictionary()
//        for key in personAttributeDictionary.keys {
//            if !currentDisplayedPersonType.attributeKeys.contains(key) {
//                personAttributeDictionary[key] = nil
//            }
//        }
//        print("\n After changingType")
//        print("\tpersonAttributeDictionary.count\(personAttributeDictionary.count)")

//        customCells = CustomCellFactory.cellsFor(
//            currentDisplayedPersonType,
//            attributeDictionary: personAttributeDictionary
//        )



//        let idx = personTypeSegmentControl.selectedSegmentIndex

        //создал словарь атрибутов прошлого персон
//        if let pastPerson = self.person {
//            personAttributeDictionary = pastPerson.attributeDictionary
//        }

//        guard let newPerson = self.coreDataStack.createEntityWithOrderIndex(idx) as? Person else {
//            fatalError("Expected a subclass of Person")
//        }

//        if let pastPerson = self.person {
//            newPerson.copyAttributesFrom(pastPerson)
//            self.coreDataStack.mainQueueContext.deleteObject(pastPerson)
//            // NOTE: не сохраняем контекст, потому что новый (незаполненный)
//            // объект тоже сохранится
//        }

//        self.person = newPerson
        updateArrayOfFilledAttribute()

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

    private func updateArrayOfFilledAttribute() {
        var tempArray = [String]()

        guard let newPersonAtributeKeys =  self.person?.personDisplayedAttributeKeys
            else {return}

        for key in arrayOfFilledAttributes {
            if newPersonAtributeKeys.contains(key) {
                tempArray.append(key)
            }
        }
        arrayOfFilledAttributes = tempArray

//        checkValid()
    }

    func checkValid() {
        print("\n\n----checkValid----")
        guard
            let filledAttributeKeys = personAttributeDictionary?
                                                    .valuesDictionary
                                                    .keys,
            let allAttributeKeys = personAttributeDictionary?
                                                    .displayedPersonType
                                                    .attributeKeys
        else {
            print("Блокирую кнопку Save")
            self.navigationItem.rightBarButtonItem?.enabled = false
            return
        }

        print("allAttributeKeys =\n \(allAttributeKeys)")
        print("filledAttributeKeys =\n \(filledAttributeKeys)")

        var canTapSave = true
        for key in allAttributeKeys {
            if !filledAttributeKeys.contains(key) {
                canTapSave = false
            }
        }
        print("Могу нажать на Save - \(canTapSave)")
        self.navigationItem.rightBarButtonItem?.enabled = canTapSave
        print("\n\n--------")
    }

    private func addNewKeyForValid(key: String) {

        if !arrayOfFilledAttributes.contains(key) {
            arrayOfFilledAttributes.append(key)
        }
//        checkValid()
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

   // swiftlint:disable function_body_length
//    private func cellForProperty(attributeKey: String, attributeValue: AnyObject ) -> CustomTableViewCell? {
//
//        let avalibleTypeForCellWithSimpeTextField = [
//            NSAttributeType.StringAttributeType,
//            NSAttributeType.Integer32AttributeType,
//            NSAttributeType.DoubleAttributeType]
//
//
//        guard
//            let attributeDescription = PersonAttributeDescription(
//                attributeKey: attributeKey)?.description,
//            let attributePlaceholder = PersonAttributeDescription(
//                attributeKey: attributeKey)?.placeholder
//        else {
//            fatalError("fatalError: Attribute doesn't conform")
//        }
//
//        let attributeType = personAttribute.attributeType
//
//        //если атрибут составной, то получаем значения по 2 ключам
//        if personAttribute.optional {
//            guard let valueKeys = personAttribute.userInfo?["keys"] as? [String]
//                else {
//                    fatalError("Составной атибут не имеет значения в  userInfo['keys'] ")
//            }
//
//            let cell =  DateInputViewCell(
//                description: [
//                    attributeDescription,
//                    attributePlaceholder
//                ],
//                startTime: self.person?.valueForKey(valueKeys[0]) as? NSDate,
//                endTime: self.person?.valueForKey(valueKeys[1]) as? NSDate,
//                action: { (startDate, endDate) in
//                    self.person?.setValue(startDate, forKey: valueKeys[0])
//                    self.person?.setValue(endDate, forKey: valueKeys[1])
//                    self.addNewKeyForValid(valueKeys[0])
//                    self.addNewKeyForValid(valueKeys[1])
//                },
//                actionForClearField: {
//                    self.arrayOfFilledAttributes.removeObjectsInArray(valueKeys)
//                    self.checkValid()
//                })
//
//            cell.delegate = self
//            return cell
//        }
//
//        let attributeValue = self.person?.valueForKey(personAttribute.name)
//
//        if personAttribute.name == "type" {
//            let cell = PickerInputViewCell(
//                description: [
//                    attributeDescription,
//                    attributePlaceholder
//                ],
//                data: attributeValue,
//                action: { (data) in
//                    self.person?.setValue(data, forKey: personAttribute.name)
//                    self.addNewKeyForValid(personAttribute.name)
//                },
//                actionForClearField: {
//                    self.arrayOfFilledAttributes.removeObject(personAttribute.name)
//                    self.checkValid()
//                })
//            cell.delegate = self
//            return cell
//        }
//

//            let cell = SimpleTextFieldCell(
//                description: [
//                    attributeDescription,
//                    attributePlaceholder
//                ],
//                data: attributeValue,
//
//                action: { (data) in
//                    self.personAttributeDictionary[attributeKey] = data
////                    self.person?.setValue(data, forKey: personAttribute.name)
////                    self.addNewKeyForValid(personAttribute.name)
//                },
//                actionForClearField: {
//                    self.arrayOfFilledAttributes.removeObject(personAttribute.name)
//                    self.checkValid()
//                })
//            cell.delegate = self
//            return cell
//
//        return nil
//    }
//
//    // swiftlint:enable function_body_length
}

//MARK: -
//MARK: Extension
//MARK: - DelegateForPersonAttributeDictionary
extension PersonDetailViewController: DelegateForPersonAttributeDictionary {
    func userEnteredData() {
        checkValid()
    }
}
//extension PersonDetailViewController: DelegateForCustomCell {
//    func cellBeginEditing() {
//        self.navigationItem.leftBarButtonItem?.enabled = false
//        self.personTypeSegmentControl.enabled = false
//        self.navigationItem.rightBarButtonItem?.enabled = false
//    }
//    func cellDidEndEditing() {
//        self.navigationItem.leftBarButtonItem?.enabled = true
//        self.personTypeSegmentControl.enabled = true
//        self.navigationItem.rightBarButtonItem?.enabled = true
//    }
//}
//MARK: - UITableViewDelegate
extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        switch state?.isBrowsing() {
        case (true?):
            cell.userInteractionEnabled = false
            cell.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        default:
            cell.userInteractionEnabled = true
            cell.backgroundColor = UIColor.whiteColor()
        }

//        if personTypeSegmentControl.selectedSegmentIndex != UISegmentedControlNoSegment {
//            self.customTableView.backgroundView?.hidden = true
//        }
    }

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // Return the number of rows for each section in your static table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("for \(personAttributeDictionary?.displayedPersonType)")
//        print("numberOfRowsInSection = \(personAttributeDictionary?.displayedPersonType.numberDisplayedAttributes ?? 0)")
        return personAttributeDictionary?.displayedPersonType
            .numberDisplayedAttributes ?? 0
    }

    // Return the row for the corresponding section and row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath")
        print("customCells.count = \(customCells.count)")
//        print("\(currentDisplayedPersonType?.description).AtrCount = \(currentDisplayedPersonType?.attributeKeys.count)")

        return customCells[indexPath.row]
//        return UITableViewCell()
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Profile"
        default:
            fatalError("Unknown section")
        }
    }
}
