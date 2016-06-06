//
//  GuidanceTableViewswift
//  TestApplication
//
//  Created by developer on 10.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class GuidanceTableViewCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var visitingHoursLabel: UILabel!

    func updateUI(guidance: Guidance) {
        fullNameLabel.text = guidance.fullName
        salaryLabel.text = guidance.salary?.stringValue

        switch (guidance.startVisitingHours?.timeFormat,
                guidance.endVisitingHours?.timeFormat) {
        case let (fromTime?, toTime?):
            visitingHoursLabel.text = "From \(fromTime) to \(toTime)"
        default:
            break
        }
    }

}
