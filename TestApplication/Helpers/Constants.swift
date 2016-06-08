//
//  Constants.swift
//  TestApplication
//
//  Created by developer on 11.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import BNRCoreDataStack

struct UserInfoKeys {
    static let entityOrderIndex = "orderIndex"
    static let attributeDescription = "description"
    static let attributePlaceholder = "placeholder"
    static let attributeOrderIndex = "orderIndex"
}

enum PersonAttributeDescription: String, CustomStringConvertible {
    case FullName = "fullName"
    case Salary = "salary"
    case EndVisitingHours = "endVisitingHours"
    case StartVisitingHours = "startVisitingHours"
    case EndMealTime = "endMealTime"
    case StartMealTime = "startMealTime"
    case WorkplaceNumber = "workplaceNumber"
    case AccountantType = "accountantType"
struct PersonAttributeKeys {
    static let fullName = "fullName"
    static let salary = "salary"
    static let startVisitingHours = "startVisitingHours"
    static let endVisitingHours = "endVisitingHours"
    static let workplaceNumber = "workplaceNumber"
    static let startMealTime = "startMealTime"
    static let endMealTime = "endMealTime"
    static let accountantType = "accountantType"
}

    init?(attributeKey: String) {
        switch attributeKey {
        case FullName.rawValue:
            self = .FullName
        case Salary.rawValue:
            self = .Salary
        case EndVisitingHours.rawValue:
            self = .EndVisitingHours
        case StartVisitingHours.rawValue:
            self = .StartVisitingHours
        case EndMealTime.rawValue:
            self = .EndMealTime
        case StartMealTime.rawValue:
            self = .StartMealTime
        case WorkplaceNumber.rawValue:
            self = .WorkplaceNumber
        case AccountantType.rawValue:
            self = .AccountantType
        default:
            return nil
        }
    }

    var description: String {
        switch self {
        case FullName:
            return "Full name:"
        case Salary:
            return "Salary:"
        case EndVisitingHours:
            return "EndVisitingHours"
        case StartVisitingHours:
            return "StartVisitingHours"
        case EndMealTime:
            return "End mealTime"
        case StartMealTime:
            return "Start meal time:"
        case WorkplaceNumber:
            return "Workplace number:"
        case AccountantType:
            return "Accountant type:"
        }
    }

    var placeholder: String {
        switch self {
        case FullName:
            return "Петров Сергей Иванович"
        case Salary:
            return "20000"
        case AccountantType:
            return "Material Accounting"
        case WorkplaceNumber:
            return "555"
        case EndVisitingHours:
            return "from 16:00 to 18:00"
        case StartVisitingHours:
            return "from 16:00 to 18:00"
        case EndMealTime:
            return "from 13:00 to 14:00"
        case StartMealTime:
            return "from 13:00 to 14:00"
        }
    }

//    var type: NSAttributeType {
//        switch self {
//        case FullName:
//            return NSAttributeType.StringAttributeType
//        case Salary:
//            return NSAttributeType.DoubleAttributeType
//        case AccountantType,WorkplaceNumber:
//            return "Material Accounting"
//        case WorkplaceNumber:
//            return "555"
//        case StartMealTime,EndMealTime,StartVisitingHours,EndVisitingHours:
//            return NSAttributeType.DateAttributeType
//        }
    }

enum AccountantType: CustomStringConvertible {
    case SalaryAccounting
    case MaterialAccounting

    static let count = 2

    var description: String {
        switch self {
        case SalaryAccounting:
            return "Salary Accounting"
        case MaterialAccounting:
            return "Material Accounting"
        }
    }

    init(index: Int) {
        switch index {

        case -1, 0:
            self = .SalaryAccounting
        case 1:
            self = .MaterialAccounting
        default:
            fatalError("invalid index of AccountantType")
        }
    }
}
