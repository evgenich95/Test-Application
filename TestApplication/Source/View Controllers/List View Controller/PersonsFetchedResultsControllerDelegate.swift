//
//  PersonsFetchedResultsControllerDelegate.swift
//  TestApplication
//
//  Created by developer on 10.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit
import BNRCoreDataStack

class PersonsFetchedResultsControllerDelegate: FetchedResultsControllerDelegate {
    weak var tableView: UITableView?

    // MARK: - Lifecycle

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    func fetchedResultsControllerDidPerformFetch(controller: FetchedResultsController<Person>) {
        tableView?.reloadData()
    }

    func fetchedResultsControllerWillChangeContent(controller: FetchedResultsController<Person>) {
        tableView?.beginUpdates()
    }

    func fetchedResultsControllerDidChangeContent(controller: FetchedResultsController<Person>) {
        tableView?.endUpdates()
    }

    func fetchedResultsController(controller: FetchedResultsController<Person>,
                                  didChangeObject change: FetchedResultsObjectChange<Person>) {
        switch change {
        case let .Insert(_, indexPath):
            tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

        case let .Delete(_, indexPath):
            tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

        case let .Move(_, fromIndexPath, toIndexPath):
            tableView?.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)

        case let .Update(_, indexPath):
            tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    func fetchedResultsController(controller: FetchedResultsController<Person>,
                                  didChangeSection change: FetchedResultsSectionChange<Person>) {
        switch change {
        case let .Insert(_, index):
            tableView?.insertSections(NSIndexSet(index: index), withRowAnimation: .Automatic)

        case let .Delete(_, index):
            tableView?.deleteSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
        }
    }
}
