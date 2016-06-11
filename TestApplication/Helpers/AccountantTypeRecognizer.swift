//
//  AccountantTypeRecognizerRecognizer.swift
//  TestApplication
//
//  Created by developer on 11.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

enum AccountantTypeRecognizer: CustomStringConvertible {
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