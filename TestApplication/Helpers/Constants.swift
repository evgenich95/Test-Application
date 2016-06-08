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

enum PersonAttributeDescription: CustomStringConvertible {
    case FullName
    case Salary
//    case EndVisitingHours = "endVisitingHours"
//    case StartVisitingHours = "startVisitingHours"
//    case EndMealTime = "endMealTime"
//    case StartMealTime = "startMealTime"
    case WorkplaceNumber
    case AccountantType
    case VisitingHours
    case MealTime

    init?(attributeKey: String) {
        switch attributeKey {
        case PersonAttributeKeys.fullName:
            self = .FullName
        case PersonAttributeKeys.salary:
            self = .Salary
        case PersonAttributeKeys.endVisitingHours,
             PersonAttributeKeys.startVisitingHours:
            self = .VisitingHours
        case PersonAttributeKeys.endMealTime,
             PersonAttributeKeys.startMealTime:
            self = .MealTime
        case PersonAttributeKeys.workplaceNumber:
            self = .WorkplaceNumber
        case PersonAttributeKeys.accountantType:
            self = .AccountantType
            //        case StartVisitingHours.rawValue:
            //            self = .StartVisitingHours
            //        case EndMealTime.rawValue:
        //            self = .EndMealTime
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
        case WorkplaceNumber:
            return "Workplace number:"
        case AccountantType:
            return "Accountant type:"
        case .VisitingHours:
            return "Visiting hours:"
        case .MealTime:
            return "Meal time:"
            //        case EndVisitingHours:
            //            return "EndVisitingHours"
            //        case StartVisitingHours:
            //            return "StartVisitingHours"
            //        case EndMealTime:
            //            return "End mealTime"
            //        case StartMealTime:
            //            return "Start meal time:"
        }
    }

    var key: [String] {
        switch self {
        case FullName:
            return [PersonAttributeKeys.fullName]
        case Salary:
            return [PersonAttributeKeys.salary]
        case AccountantType:
            return [PersonAttributeKeys.accountantType]
        case WorkplaceNumber:
            return [PersonAttributeKeys.workplaceNumber]
        case .VisitingHours:
            return [
                PersonAttributeKeys.endVisitingHours,
                PersonAttributeKeys.startVisitingHours
            ]
        case .MealTime:
            return [
                PersonAttributeKeys.startMealTime,
                PersonAttributeKeys.endMealTime
            ]
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
        case .VisitingHours:
            return "from 16:00 to 18:00"
        case .MealTime:
            return "from 13:00 to 14:00"
//        case EndVisitingHours:
//            return "from 16:00 to 18:00"
//        case StartVisitingHours:
//            return "from 16:00 to 18:00"
//        case EndMealTime:
//            return "from 13:00 to 14:00"
//        case StartMealTime:
//            return "from 13:00 to 14:00"
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
