//
//  NSDate+addSubstructMinute.swift
//  TestApplication
//
//  Created by developer on 10.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

extension NSDate {
    func byAddingMinutes(minute: Int) -> NSDate! {
        return NSCalendar.currentCalendar()
            .dateByAddingUnit(.Minute,
                              value: minute,
                              toDate: self,
                              options: [])
    }

    func bySubtractingMinutes(minute: Int) -> NSDate! {
        return  self.byAddingMinutes(-1*minute)
    }
}
