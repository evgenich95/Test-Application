//
//  WebService.swift
//  TestApplication
//
//  Created by developer on 18.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

struct WebService {

    typealias CompletionHandler = ((response: [Quote]?, error: NSError?) -> Void)
    static let baseURL: String = "http://storage.space-o.ru/testXmlFeed.xml"

    static func getQuotes(url: String = baseURL, completionHandler: CompletionHandler) {

        Alamofire.request(.GET, url)
            .response { request, response, data, error in
                if let error = error {
                    completionHandler(response: nil, error: error)
                    return
                }
                do {
                    if let data = data {
                        let xml = SWXMLHash.parse(data)
                        let quotes: [Quote] = try xml["result"]["quotes"]["quote"].value()
                        completionHandler(response: quotes, error: nil)
                    }
                } catch {
                    let error = NSError(domain: "Current URL not supported", code: -1, userInfo: nil)
                    completionHandler(response: nil, error: error)
                }
        }
    }
}
