//
//  BookkeepingTableViewswift
//  TestApplication
//
//  Created by developer on 10.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class BookkeepingTableViewCell: UITableViewCell {

    @IBOutlet weak internal var fullNameLabel: UILabel!

    @IBOutlet weak internal var salaryLabel: UILabel!

    @IBOutlet weak internal var workplaeNumberLabel: UILabel!

    @IBOutlet weak internal var mealTimeLabel: UILabel!

    @IBOutlet weak var bokkeepingTypeLabel: UILabel!

    func updateUI(bookkeeping: Bookkeeping) {
        fullNameLabel.text = bookkeeping.fullName
        salaryLabel.text = bookkeeping.salary?.stringValue

        switch (bookkeeping.startMealTime?.timeFormat,
                bookkeeping.endMealTime?.timeFormat) {
        case let (fromTime?, toTime?):
            mealTimeLabel.text = "From \(fromTime) to \(toTime)"
        default: break
        }

        workplaeNumberLabel.text = bookkeeping.workplaceNumber?.stringValue
        bokkeepingTypeLabel.text = BookkeepingType(index: bookkeeping.type?.integerValue ?? -1).description
    }
}
