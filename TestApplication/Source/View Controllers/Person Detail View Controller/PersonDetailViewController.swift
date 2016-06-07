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

    var arrayOfFilledAttributes = [String]()

    //MARK: -
    //MARK: Lazy parameters
    lazy private var hintView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)

        let hintLabel = UILabel()
        hintLabel.adjustsFontSizeToFitWidth = true
        hintLabel.textAlignment = .Center
        hintLabel.numberOfLines = 0
        hintLabel.font = UIFont(name: "Helvetica Neue", size: 30)
        hintLabel.textColor = UIColor.grayColor()
        hintLabel.text = "Please, select a New person type"

        view.addSubview(hintLabel)

        hintLabel.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(view)
            make.center.equalTo(view)
            make.height.lessThanOrEqualTo(view.snp_height).dividedBy(2)
        }
        return view
    }()

    lazy var customTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundView = self.hintView
        self.view.addSubview(table)
        return table
    }()

    lazy var personTypeSegmentControl: UISegmentedControl = {

        let entityNames = self.coreDataStack.entityNamesSortedByOrderIndex()
        let segment = UISegmentedControl(items: entityNames)

        if let _ = self.person {
            segment.enabled = self.editing
        }
        //если тип Person выбран, то отображаем данные tableView
        //иначе выводим table.backgroundView = self.hintView
        switch self.person?.entityOrderIndex {
        case let (index?):
            segment.selectedSegmentIndex = index
            self.changeStateToBrowsing()
        default:
            self.customTableView.dataSource = nil
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
        configureView()

        //Если segment не выбран, значит переходим в режим Создания
        if personTypeSegmentControl.selectedSegmentIndex == UISegmentedControlNoSegment {
            changeStateToCreating()
        }
    }

    //MARK: addTarget's functions
    @objc func segmentControlChangeValue(sender: UISegmentedControl) {
        let idx = personTypeSegmentControl.selectedSegmentIndex

        guard let newPerson = self.coreDataStack.createEntityWithOrderIndex(idx) as? Person else {
            fatalError("Expected a subclass of Person")
        }

        if let pastPerson = self.person {
            newPerson.copyAttributesFrom(pastPerson)
            self.coreDataStack.mainQueueContext.deleteObject(pastPerson)
            // NOTE: не сохраняем контекст, потому что новый (незаполненный)
            // объект тоже сохранится
        }

        self.person = newPerson
        updateArrayOfFilledAttribute()
        self.customTableView.dataSource = self
        self.customTableView.reloadData()
    }

    //MARK: Help functions
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

        checkValid()
    }

    func checkValid() {
        guard let person = self.person else {
            self.navigationItem.rightBarButtonItem?.enabled = false
            return
        }

        let personAttributeKeys = person.personDisplayedAttributeKeys

        var canTapSave = true
        for key in personAttributeKeys {
            if !arrayOfFilledAttributes.contains(key) {
                canTapSave = false
            }
        }

        self.navigationItem.rightBarButtonItem?.enabled = canTapSave
    }

    private func addNewKeyForValid(key: String) {

        if !arrayOfFilledAttributes.contains(key) {
            arrayOfFilledAttributes.append(key)
        }
        checkValid()
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
    private func cellForProperty(personAttribute: NSAttributeDescription) -> CustomTableViewCell? {

        let avalibleTypeForCellWithSimpeTextField = [
            NSAttributeType.StringAttributeType,
            NSAttributeType.Integer32AttributeType,
            NSAttributeType.DoubleAttributeType]

        guard
            let attributeDescription = personAttribute.userInfo?[UserInfoKeys.attributeDescription] as? String,
            let attributePlaceholder = personAttribute.userInfo?[UserInfoKeys.attributePlaceholder] as? String
        else {
            fatalError("fatalError: Attribute doesn't conform")
        }

        let attributeType = personAttribute.attributeType

        //если атрибут составной, то получаем значения по 2 ключам
        if personAttribute.optional {
            guard let valueKeys = personAttribute.userInfo?["keys"] as? [String]
                else {
                    fatalError("Составной атибут не имеет значения в  userInfo['keys'] ")
            }

            let cell =  DateInputViewCell(
                description: [
                    attributeDescription,
                    attributePlaceholder
                ],
                startTime: self.person?.valueForKey(valueKeys[0]) as? NSDate,
                endTime: self.person?.valueForKey(valueKeys[1]) as? NSDate,
                action: { (startDate, endDate) in
                    self.person?.setValue(startDate, forKey: valueKeys[0])
                    self.person?.setValue(endDate, forKey: valueKeys[1])
                    self.addNewKeyForValid(valueKeys[0])
                    self.addNewKeyForValid(valueKeys[1])
                },
                actionForClearField: {
                    self.arrayOfFilledAttributes.removeObjectsInArray(valueKeys)
                    self.checkValid()
                })

            cell.delegate = self
            return cell
        }

        let attributeValue = self.person?.valueForKey(personAttribute.name)

        if personAttribute.name == "type" {
            let cell = PickerInputViewCell(
                description: [
                    attributeDescription,
                    attributePlaceholder
                ],
                data: attributeValue,
                action: { (data) in
                    self.person?.setValue(data, forKey: personAttribute.name)
                    self.addNewKeyForValid(personAttribute.name)
                },
                actionForClearField: {
                    self.arrayOfFilledAttributes.removeObject(personAttribute.name)
                    self.checkValid()
                })
            cell.delegate = self
            return cell
        }

        if avalibleTypeForCellWithSimpeTextField.contains(attributeType) {
            let cell = SimpleTextFieldCell(
                description: [
                    attributeDescription,
                    attributePlaceholder
                ],
                data: attributeValue,
                inputDataType: attributeType,
                action: { (data) in
                    self.person?.setValue(data, forKey: personAttribute.name)
                    self.addNewKeyForValid(personAttribute.name)
                },
                actionForClearField: {
                    self.arrayOfFilledAttributes.removeObject(personAttribute.name)
                    self.checkValid()
                })
            cell.delegate = self
            return cell
        }
        return nil
    }

    // swiftlint:enable function_body_length
}

//MARK: -
//MARK: Extension
//MARK: - DelegateForCustomCell
extension PersonDetailViewController: DelegateForCustomCell {
    func cellBeginEditing() {
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.personTypeSegmentControl.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    func cellDidEndEditing() {
        self.navigationItem.leftBarButtonItem?.enabled = true
        self.personTypeSegmentControl.enabled = true
        self.navigationItem.rightBarButtonItem?.enabled = true
    }
}
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
            break
        }

        if personTypeSegmentControl.selectedSegmentIndex != UISegmentedControlNoSegment {
            self.customTableView.backgroundView?.hidden = true
        }
    }

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // Return the number of rows for each section in your static table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let numberOfPatameters = self.person?.entity.properties.count {
            //-2, т.к. во всех dataRange представлен 2 поля start и end
            return numberOfPatameters-2
        }

        return 0
    }

    // Return the row for the corresponding section and row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        guard let attributes = self.person?.personAttributesByName
            else {
                fatalError("entity \(self.person?.entity.name) is absent for displaying")
        }
        
        if let cell =  cellForProperty(attributes[indexPath.row]) {
            return cell
        }
        
        return UITableViewCell()
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
