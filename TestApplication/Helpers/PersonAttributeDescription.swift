//
//  PersonAttributeDescription.swift
//  TestApplication
//
//  Created by developer on 09.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

enum PersonAttributeDescription: CustomStringConvertible {
    case FullName
    case Salary
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