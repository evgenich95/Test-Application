//
//  ServiceTableViewCell.swift
//  TestApplication
//
//  Created by developer on 18.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textQuoteLabel: UILabel!

    func updateUI(quote: Quote) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, hh:mm"

        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(
            string: dateFormatter.stringFromDate(quote.date),
            attributes: underlineAttribute
        )

        dateLabel.attributedText = underlineAttributedString
        textQuoteLabel.text = quote.text
    }
}
