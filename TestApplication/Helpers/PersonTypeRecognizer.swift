//
//  personTypeRecognizer.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

enum PersonTypeRecognizer: CustomStringConvertible {
    case ManagerType
    case WorkerType
    case AccountantType

    init?(aPerson: Person?) {
        switch aPerson?.entity.name ?? "" {
            case Accountant.entityName:
                self = .AccountantType
            case Manager.entityName:
                self = .ManagerType
            case Worker.entityName:
                self = .WorkerType
            default:
                return nil
            }
    }

    var description: String {
        switch self {
            case .ManagerType:
                return "Manager"
            case .WorkerType:
                return "Worker"
            case .AccountantType:
                return "Accountant"
            }
    }

    var orderIndex: Int {
        switch self {
            case .ManagerType:
                return 0
            case .WorkerType:
                return 1
            case .AccountantType:
                return 2
            }
    }
}
