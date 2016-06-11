//
//  NSDate+addSubstructMinute.swift
//  TestApplication
//
//  Created by developer on 10.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

extension NSDate {
    static func addMinuteToDate(minute: Int, date: NSDate) -> NSDate! {
        return NSCalendar.currentCalendar()
            .dateByAddingUnit(.Minute,
                              value: minute,
                              toDate: date,
                              options: [])
    }

    static func subscriptMinuteToDate(minute: Int, date: NSDate) -> NSDate! {
        return self.addMinuteToDate(-1*minute, date: date)
    }
}
