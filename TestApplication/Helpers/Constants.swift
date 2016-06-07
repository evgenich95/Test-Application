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
