//
//  EmployeeTableViewHeader.swift
//  TestApplication
//
//  Created by developer on 07.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import SnapKit

class EmployeeTableViewHeader: UITableViewHeaderFooterView {

    var sectionIcon = UIImageView()
    var sectionName = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        createView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createView() {
        self.contentView.backgroundColor = UIColor
                                                .lightGrayColor()
                                                .colorWithAlphaComponent(0.3)
        sectionName.textColor = UIColor(red: 0.0,
                                        green: 122/255,
                                        blue: 1.0,
                                        alpha: 1)
        self.addSubview(sectionIcon)
        self.addSubview(sectionName)

        sectionIcon.snp_makeConstraints {(make) -> Void in
            make.top.bottom.equalTo(self)
            make.width.equalTo(sectionIcon.snp_height)
            make.leading.equalTo(self).offset(8)
        }

        sectionName.snp_makeConstraints {(make) -> Void in
            make.top.bottom.equalTo(self)
            make.left.equalTo(sectionIcon.snp_right).offset(8)
        }
    }

    func updateUI(sectionName: String, sectionIconName: String) {
        sectionIcon.image = UIImage(named: sectionIconName)
        self.sectionName.text = sectionName
    }
}
