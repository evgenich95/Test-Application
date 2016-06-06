//
//  Quote.swift
//  TestApplication
//
//  Created by developer on 18.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import SWXMLHash

struct Quote: XMLIndexerDeserializable {
    let text: String
    let ids: Int
    let date: NSDate

    static func deserialize(node: XMLIndexer) throws -> Quote {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, hh:mm"

        var date: NSDate?

        let stringForDate = node["date"].element?.text
        if let string = stringForDate {
            date = dateFormatter.dateFromString(string)
        }

        return try Quote(
            text: node["text"].value(),
            ids: node["id"].value(),
            date: date ?? NSDate()
        )
    }
}
