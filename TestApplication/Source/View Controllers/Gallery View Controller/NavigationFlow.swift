//
//  NavigationFlow.swift
//  TestApplication
//
//  Created by developer on 23.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

enum NavigationDirection: Int {
    case Left = -1
    case Rigth = 1
}

struct NavigationFlow {

    var direction: NavigationDirection?
    var imagesCacheDimension: Int

    init(imagesCacheDimension: Int) {
        self.imagesCacheDimension = imagesCacheDimension
    }

    private var numberPhotoInOppositeNavigationDirection: Int {
        if imagesCacheDimension % 2 == 0 &&
            direction == .Rigth {
            return imagesCacheDimension/2-1
        } else {
            return imagesCacheDimension/2
        }
    }

    private var numberPhotoInThisNavigationDirection: Int {
        if imagesCacheDimension % 2 == 0 &&
            direction == .Left {
            return imagesCacheDimension/2-1
        } else {
            return imagesCacheDimension/2
        }
    }

    func indexOfPhotoToDelete(forPage page: Int) -> Int {
        return page -
            ((numberPhotoInOppositeNavigationDirection) + 1)
            * (direction?.rawValue ?? 0)
    }

    func indexOfPhotoToLoad(forPage page: Int) -> Int {
        return page + (numberPhotoInThisNavigationDirection ?? 0)
            * (direction?.rawValue ?? 0)
    }
}
