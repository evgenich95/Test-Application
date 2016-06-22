//
//  UIViewController+handleError.swift
//  WeatherToday
//
//  Created by developer on 28.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func handleError (error: NSError, retryAction: () -> Void, cancelAction: (() -> Void)?) {

        let detectedError = NetworkError(error: error)

        let alertController = UIAlertController(title: "Error", message: detectedError.description, preferredStyle: .Alert)

        let retryAction = UIAlertAction(title: "Try again", style: .Default) { (_) in retryAction() }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {(_) in cancelAction?() }

        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
