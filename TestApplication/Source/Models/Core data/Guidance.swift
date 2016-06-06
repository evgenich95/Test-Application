//
//  Guidance.swift
//  TestApplication
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData


class Guidance: Person {
    @NSManaged var startVisitingHours: NSDate?
    @NSManaged var endVisitingHours: NSDate?

    override class var entityName: String {
        return "Guidance"
    }
}
