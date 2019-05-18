//
//  CurrencyListRepository.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

struct CurrencyListRepository: Repositable {
    static let shared = CurrencyListRepository(storage: StorageManager.shared)
    
    let storage: StorageManager
    private let storageKey = "all"
    
    struct Data: StorageData {
        let list: [CurrencyEntity]
    }
 
    private init(storage: StorageManager) {
        self.storage = storage
    }
    
    func get() -> (lastSavedDate: Date, data: CurrencyListRepository.Data)? {
        return get(key: storageKey)
    }
    
    func set(data: CurrencyListRepository.Data) {
        set(key: storageKey, data: data)
    }
}
