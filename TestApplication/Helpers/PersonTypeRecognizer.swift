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

    init?(orderIndex: Int) {
        switch orderIndex {
        case 0:
            self = .ManagerType
        case 1:
            self = .WorkerType
        case 2:
            self = .AccountantType
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

    var attributeDictionary: [String: AnyObject] {
        print("\nPersonTypeRecognizer")
        var attributeDictionary = [String: AnyObject]()
        var keys = [String]()
        
        switch self {
        case .ManagerType:
            keys = Manager.keys
        case .WorkerType:
            keys = Worker.keys
        case .AccountantType:
            keys = Accountant.keys
        }

//        for key in keys {
//            attributeDictionary.
//        }
        keys.forEach() {
            attributeDictionary[$0] = ""
            print("key = \($0)")
        }
        print("attributeDictionary = \(attributeDictionary)\n")
        return attributeDictionary
    }
}
