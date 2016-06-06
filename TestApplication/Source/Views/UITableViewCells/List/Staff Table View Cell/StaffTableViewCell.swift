//
//  StaffTableViewswift
//  TestApplication
//
//  Created by developer on 10.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class StaffTableViewCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!

    @IBOutlet weak var salaryLabel: UILabel!

    @IBOutlet weak var workplaeNumberLabel: UILabel!

    @IBOutlet weak var mealTimeLabel: UILabel!

    func updateUI(staff: Staff) {
        fullNameLabel.text = staff.fullName
        salaryLabel.text = staff.salary?.stringValue

        switch (staff.startMealTime?.timeFormat,
                staff.endMealTime?.timeFormat) {
        case let(fromTime?, toTime?):
            mealTimeLabel.text = "From \(fromTime) to \(toTime)"
        default: break
        }

        workplaeNumberLabel.text = staff.workplaceNumber?.stringValue
    }
}
