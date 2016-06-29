//
//  AppDelegate.swift
//  TestApplication
//
//  Created by developer on 05.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData
import BNRCoreDataStack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//    private var coreDataStack: CoreDataStack?

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("TestApplication", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        let persistentStoreCoordinator = self.persistentStoreCoordinator

        // Initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)

        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        // URL Documents Directory
        let URLs = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let applicationDocumentsDirectory = URLs[(URLs.count - 1)]

        // URL Persistent Store
        let URLPersistentStore = applicationDocumentsDirectory.URLByAppendingPathComponent("TestApplication.sqlite")

        do {
            // Add Persistent Store to Persistent Store Coordinator
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: URLPersistentStore, options: nil)

        } catch {
            // Populate Error
            var userInfo = [String: AnyObject]()
            userInfo[NSLocalizedDescriptionKey] = "There was an error creating or loading the application's saved data."
            userInfo[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."

            userInfo[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.tutsplus.Done", code: 1001, userInfo: userInfo)

            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")

            abort()
        }
        
        return persistentStoreCoordinator
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {


        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = LaunchViewController()

        let mainViewController = StartViewController(managedObjectContext: self.managedObjectContext)

        
        let navController = UINavigationController(rootViewController: mainViewController)

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }


//    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window?.rootViewController = LaunchViewController()
//
//        CoreDataStack.constructSQLiteStack(withModelName: "TestApplication") { result in
//            switch result {
//            case .Success(let stack):
//                self.coreDataStack = stack
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.window?.rootViewController = StartViewController(coreDataStack: stack)
//                }
//            case .Failure(let error):
//                assertionFailure("\(error)")
//            }
//        }
//
//        window?.makeKeyAndVisible()
//        return true
//    }

    func applicationDidEnterBackground(application: UIApplication) {
//        guard let stack = self.managedObjectContext else {
//            assertionFailure("Stack was not setup first")
//            return
//        }
//        stack.saveAndLog()

        do {
            try self.managedObjectContext.save()
        } catch {
            NSLog("\(error)")
        }
    }
}
