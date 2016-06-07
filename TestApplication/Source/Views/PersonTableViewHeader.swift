//
//  PersonTableViewHeader.swift
//  TestApplication
//
//  Created by developer on 07.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

class PersonTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var sectionIcon: UIImageView!
    
    @IBOutlet weak var sectionName: UILabel!

    func updateUI(sectionName: String, sectionIconName: String) {
        sectionIcon.setImageWithoutCache(sectionIconName)
        self.sectionName.text = sectionName
    }
}
