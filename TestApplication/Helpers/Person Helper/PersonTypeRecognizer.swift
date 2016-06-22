//
//  EmployeeType.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
typealias ManagerClass = Manager
typealias WorkerClass = Worker
typealias AccountantClass = Accountant

enum EmployeeType: CustomStringConvertible {
    case Manager
    case Worker
    case Accountant

    init?(aPerson: Person?) {
        switch aPerson?.entity.name ?? "" {
        case AccountantClass.entityName:
            self = .Accountant
        case ManagerClass.entityName:
            self = .Manager
        case WorkerClass.entityName:
            self = .Worker
        default:
            return nil
        }
    }

    init?(orderIndex: Int) {
        switch orderIndex {
        case 0:
            self = .Manager
        case 1:
            self = .Worker
        case 2:
            self = .Accountant
        default:
            return nil
        }
    }

    var description: String {
        switch self {
        case .Manager:
            return "Manager"
        case .Worker:
            return "Worker"
        case .Accountant:
            return "Accountant"
        }
    }

    var orderIndex: Int {
        switch self {
        case .Manager:
            return 0
        case .Worker:
            return 1
        case .Accountant:
            return 2
        }
    }

    var attributeKeys: [String] {

        switch self {
        case .Manager:
            return ManagerClass.keys
        case .Worker:
            return WorkerClass.keys
        case .Accountant:
            return AccountantClass.keys
        }
    }

    var numberDisplayedAttributes: Int {
        switch self {
        case .Manager:
            return ManagerClass.keys.count-1
        case .Worker:
            return WorkerClass.keys.count-1
        case .Accountant:
            return AccountantClass.keys.count-1
        }
    }
}
