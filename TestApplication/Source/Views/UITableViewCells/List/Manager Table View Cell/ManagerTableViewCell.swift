//
//  ManagerTableViewswift
//  TestApplication
//
//  Created by developer on 10.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class ManagerTableViewCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var visitingHoursLabel: UILabel!

    func updateUI(manager: Manager) {
        fullNameLabel.text = manager.fullName
        salaryLabel.text = manager.salary?.stringValue

        switch (manager.startVisitingHours?.timeFormating,
                manager.endVisitingHours?.timeFormating) {
        case let (fromTime?, toTime?):
            visitingHoursLabel.text = "From \(fromTime) to \(toTime)"
        default:
            break
        }
    }

}
