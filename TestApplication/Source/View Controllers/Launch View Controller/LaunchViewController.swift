//
//  LaunchViewController.swift
//  TestApplication
//
//  Created by developer on 04.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    init() {
        super.init(nibName: "LaunchViewController", bundle: nil)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
