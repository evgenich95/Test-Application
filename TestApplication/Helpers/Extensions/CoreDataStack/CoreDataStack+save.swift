//
//  CoreDataStack+save.swift
//  TestApplication
//
//  Created by developer on 14.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import BNRCoreDataStack

extension CoreDataStack {
    func saveAndLog() {
        do {
            try self.mainQueueContext.save()
        } catch {
            NSLog("\(error)")
        }
    }
}
