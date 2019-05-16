//
//  QuotesStorage.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

final class QuotesStorage {
    static let shared = QuotesStorage()
    
    var list = [String: [QuoteDTO]]()
    
    private init() {}
    
    func get(key: String) -> [QuoteDTO]? {
        return list.first(where: { $0.key == key })?.value
    }
    
    func set(key: String, quotes: [QuoteDTO]) {
        list[key] = quotes
    }
}
