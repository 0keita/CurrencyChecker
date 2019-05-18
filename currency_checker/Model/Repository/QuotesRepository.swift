//
//  QuotesRepository.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

struct QuotesRepository: Repositable {
    static let shared = QuotesRepository(storage: StorageManager.shared)
    typealias Data = QuoteData
    
    let storage: StorageManager
    
    struct QuoteData: StorageData {
        let list: [Quote]
    }
    
    struct Quote {
        let title: String
        let rate: Double
    }
    
    private init(storage: StorageManager) {
        self.storage = storage
    }
}
