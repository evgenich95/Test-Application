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

enum PersonAttributeDescription: CustomStringConvertible {
    case FullName
    case Salary
    case EndVisitingHours
    case StartVisitingHours
    case EndMealTime
    case StartMealTime
    case WorkplaceNumber
    case AccountantType

    init?(attributeKey: String) {
        switch attributeKey {
        case "fullName":
            self = .FullName
        case "salary":
            self = .Salary
        case "endVisitingHours":
            self = .EndVisitingHours
        case "startVisitingHours":
            self = .StartVisitingHours
        case "endMealTime":
            self = .EndMealTime
        case "startMealTime":
            self = .StartMealTime
        case "workplaceNumber":
            self = .WorkplaceNumber
        case "accountantType":
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
