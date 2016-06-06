//
//  State.swift
//  TestApplication
//
//  Created by developer on 17.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

protocol State {

    var owner: PersonDetailViewController {get set}

    init(contex: PersonDetailViewController)
    
    func isBrowsing() -> Bool
    func isCreating() -> Bool
    func isEditing () -> Bool

    func setupNavigationItem()
    func cancelAction()
    func doneAction()
}
