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
    
    let storage: StorageManager
    
    struct Data: StorageData {
        let list: [QuoteEntity]
    }
    
    private init(storage: StorageManager) {
        self.storage = storage
    }
}
