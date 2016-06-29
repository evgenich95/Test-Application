//
//  CoreDataStack+createEntityByName.swift
//  TestApplication
//
//  Created by developer on 14.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import BNRCoreDataStack

extension CoreDataStack {

    func createEntityByName(entityName: String, managesContext: NSManagedObjectContext) -> NSManagedObject {
        guard let description = NSEntityDescription
            .entityForName(entityName,
                           inManagedObjectContext: self.mainQueueContext)
        else {
            fatalError("Could not create an entity with the given name: \"\(entityName)\"")
        }

        return NSManagedObject
            .init(entity: description,
                  insertIntoManagedObjectContext: self.mainQueueContext)
    }
}
