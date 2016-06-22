//
//  WorkerTableViewswift
//  TestApplication
//
//  Created by developer on 10.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class WorkerTableViewCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!

    @IBOutlet weak var salaryLabel: UILabel!

    @IBOutlet weak var workplaeNumberLabel: UILabel!

    @IBOutlet weak var mealTimeLabel: UILabel!

    func updateUI(worker: Worker) {
        fullNameLabel.text = worker.fullName
        salaryLabel.text = worker.salary?.stringValue

        switch (worker.startMealTime?.timeString,
                worker.endMealTime?.timeString) {
        case let(fromTime?, toTime?):
            mealTimeLabel.text = "From \(fromTime) to \(toTime)"
        default: break
        }
        workplaeNumberLabel.text = worker.workplaceNumber?.stringValue
    }
}
