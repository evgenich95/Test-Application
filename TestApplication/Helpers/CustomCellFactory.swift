//
//  CustomCellFactory.swift
//  TestApplication
//
//  Created by developer on 08.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

enum CustomCellFactory {
    //возвращать нил в default или выдавать fatalError() ?!??!?!
        static func appropriateFactory(attributeDescription: PersonAttributeDescription) -> AbstractFactory? {
        switch attributeDescription {
        case .FullName, .Salary, .WorkplaceNumber:
            return SimpleTextFieldCellFactory()
        case .AccountantType:
            return PickerInputViewCellFactory()
        default:
            return nil
        }
    }

    static func cellFor(attributeKey: String, attributeDictionary: [String: AnyObject]) -> UITableViewCell {
        guard let attributeDescription = PersonAttributeDescription(attributeKey: attributeKey),
        let factory = self.appropriateFactory(attributeDescription)
            else {
                return UITableViewCell()
        }

        return factory.createCustomTableViewCell(attributeDescription, attributeDictionary: attributeDictionary)
    }
}
