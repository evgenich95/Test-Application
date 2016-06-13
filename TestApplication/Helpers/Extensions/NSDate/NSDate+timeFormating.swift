//
//  NSDate+timeFormating.swift
//  TestApplication
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

extension NSDate {
    var timeFormating: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.stringFromDate(self)
    }
}
