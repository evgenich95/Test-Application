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

    private var coreDataStack: CoreDataStack?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = LaunchViewController()

        CoreDataStack.constructSQLiteStack(withModelName: "TestApplication") { result in
            switch result {
            case .Success(let stack):
                self.coreDataStack = stack
                dispatch_async(dispatch_get_main_queue()) {
                    self.window?.rootViewController = StartViewController(coreDataStack: stack)
                }
            case .Failure(let error):
                assertionFailure("\(error)")
            }
        }

        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        guard let stack = coreDataStack else {
            assertionFailure("Stack was not setup first")
            return
        }
        stack.saveAndLog()
    }
}
