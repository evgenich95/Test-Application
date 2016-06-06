//
//  UIStackView.swift
//  WeatherToday
//
//  Created by developer on 15.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {

    func setConfigurations(axis: UILayoutConstraintAxis,
                           distribution: UIStackViewDistribution,
                           alignment: UIStackViewAlignment, spacing: CGFloat = 0) {
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
