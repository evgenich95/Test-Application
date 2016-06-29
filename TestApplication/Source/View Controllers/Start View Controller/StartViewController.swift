//
//  StartViewController.swift
//  TestApplication
//
//  Created by developer on 04.05.16.
//  Copyright © 2016 developer. All rights reserved.

import UIKit
import BNRCoreDataStack

class StartViewController: UITabBarController {

    var managedObjectContext: NSManagedObjectContext!

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupTabBar()
    }

    private func configureView() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.translucent = false
    }
    private func setupTabBar() {

        let listVC = UINavigationController(
                            rootViewController: ListPersonTableViewController(
                                managedObjectContext: managedObjectContext))
        let serviceVC = UINavigationController(
            rootViewController: ServiceTableViewController())

        let gallerymyVC = UINavigationController(
            rootViewController: GalleryViewController())

        let controllers = [listVC, gallerymyVC, serviceVC]
        self.viewControllers = controllers

        let listVCImage = UIImage(named: "list")
        let serviceVCImage = UIImage(imageLiteral: "service")
        let galleryVCImage = UIImage(imageLiteral: "gallery")
        listVC.tabBarItem = UITabBarItem(
            title: "List",
            image: listVCImage,
            tag: 1
        )
        serviceVC.tabBarItem = UITabBarItem(
            title: "Service",
            image: serviceVCImage,
            tag: 2
        )

        gallerymyVC.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: galleryVCImage,
            tag: 3
        )
    }
}
