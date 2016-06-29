//
//  EmployeeAttribute.swift
//  TestApplication
//
//  Created by developer on 09.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData

enum EmployeeAttribute: CustomStringConvertible {
    case FullName
    case Salary
    case WorkplaceNumber
    case AccountantType
    case VisitingHours
    case MealTime

    init?(attributeKey: String) {
        switch attributeKey {
        case EmployeeAttributeKeys.fullName:
            self = .FullName
        case EmployeeAttributeKeys.salary:
            self = .Salary
        case EmployeeAttributeKeys.endVisitingHours,
             EmployeeAttributeKeys.startVisitingHours:
            self = .VisitingHours
        case EmployeeAttributeKeys.endMealTime,
             EmployeeAttributeKeys.startMealTime:
            self = .MealTime
        case EmployeeAttributeKeys.workplaceNumber:
            self = .WorkplaceNumber
        case EmployeeAttributeKeys.accountantType:
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

    var keys: [String] {
        switch self {
        case FullName:
            return [EmployeeAttributeKeys.fullName]
        case Salary:
            return [EmployeeAttributeKeys.salary]
        case AccountantType:
            return [EmployeeAttributeKeys.accountantType]
        case WorkplaceNumber:
            return [EmployeeAttributeKeys.workplaceNumber]
        case .VisitingHours:
            return [
                EmployeeAttributeKeys.startVisitingHours,
                EmployeeAttributeKeys.endVisitingHours
            ]
        case .MealTime:
            return [
                EmployeeAttributeKeys.startMealTime,
                EmployeeAttributeKeys.endMealTime
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

    var possibleValues: [AnyObject]? {
        switch self {
        case AccountantType:
            return [
                "Salary Accounting",
                "Material Accounting"
            ]
        default:
            return nil
        }

    }

    var type: NSAttributeType {
        switch self {
        case FullName:
            return NSAttributeType.StringAttributeType
        case Salary:
            return NSAttributeType.DoubleAttributeType
        case AccountantType, WorkplaceNumber:
            return NSAttributeType.Integer32AttributeType
        case VisitingHours, MealTime:
            return NSAttributeType.DateAttributeType
        }
    }
}
