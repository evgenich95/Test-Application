//
//  NetworkErrorDetector.swift
//  WeatherToday
//
//  Created by developer on 28.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

enum NetworkErrorDetector: CustomStringConvertible {

    case NoInternetConnection
    case UnsupportedURL
    case UnknownError

    init(error: NSError) {
        switch error.code {
        case -1009: self = .NoInternetConnection
        case -1002, -1: self = .UnsupportedURL
        default: self = .UnknownError
        }
    }

    var description: String {
        switch self {
        case NoInternetConnection:
            return "No Internet Connection"
        case UnsupportedURL:
            return "Unsupported URL"
        case UnknownError:
            return "Unknown error"
        }
    }
}
