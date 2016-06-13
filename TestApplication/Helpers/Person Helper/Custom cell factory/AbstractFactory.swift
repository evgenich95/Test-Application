//
//  AbstractFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

protocol AbstractFactory {
    func createCustomTableViewCell(
        attributeDescription: PersonAttributeDescription,
        personAttributeContainer: PersonAttributeContainer) -> CustomTableViewCell
}
