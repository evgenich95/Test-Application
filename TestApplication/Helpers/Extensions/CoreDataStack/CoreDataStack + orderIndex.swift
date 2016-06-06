//
//  CoreDataStack + entityNames.swift
//  TestApplication
//
//  Created by developer on 14.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import BNRCoreDataStack

extension CoreDataStack {
    
    func entityNamesSortedByOrderIndex() -> [String] {
        let maybeEntities = self.mainQueueContext.persistentStoreCoordinator?.managedObjectModel.entities

        guard var entities = maybeEntities else {
            fatalError("Invalid Core Data scheme: couldn't fetch enities")
        }

        entities = entities.filter {$0.abstract == false}

        //sort by userInfo["orderIndex"]
        entities = entities.sort({ (first, second) -> Bool in

            switch (first.userInfo?["orderIndex"], second.userInfo?["orderIndex"]) {
            case let (firstIndex as NSString, secondIndex as NSString):
                if firstIndex.integerValue < secondIndex.integerValue {
                    return true
                }
                return false
            default:
                fatalError("entities haven't key=='orderIndex' in userInfo")
            }
        })

        return entities.map {$0.name ?? ""}
    }

    func createEntityWithOrderIndex(index: Int) -> NSManagedObject {
        let entityNames = entityNamesSortedByOrderIndex()
        if index >= entityNames.count {
            fatalError("Invalid orderIndex passed in createEntityWithOrderIndex()")
        }
        let entityName = entityNames[index]

        guard let description = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.mainQueueContext) else {
            fatalError("Could not create an entity with the given name: \"\(entityName)\"")
        }

        return NSManagedObject.init(entity: description, insertIntoManagedObjectContext: self.mainQueueContext)
    }
}
