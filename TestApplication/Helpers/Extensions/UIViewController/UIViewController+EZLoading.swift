//
//  UIViewController+EZLoading.swift
//  WeatherToday
//
//  Created by developer on 29.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit
import EZLoadingActivity

extension UIViewController {

    func startActivityIndicator(withText withText: String) {
        EZLoadingActivity.show(withText, disableUI: true)
    }

    func stopActivityIndicator(success: Bool? = nil) {
        if let success = success {
            EZLoadingActivity.hide(success: success, animated: true)
        } else {
            EZLoadingActivity.hide()
        }
    }
}
