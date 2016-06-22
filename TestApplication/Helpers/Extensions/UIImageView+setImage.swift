//
//  UIImageView+setImage.swift
//  TestApplication
//
//  Created by developer on 22.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func setImageWithoutCache(imageName: String?) {
        guard let
            name = imageName,
            image = UIImage(named: name),
            imageData: NSData = UIImagePNGRepresentation(image)
        else {
            self.image = nil
            return
        }
        self.image = UIImage(data: imageData)
    }
}
