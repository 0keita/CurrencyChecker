//
//  CurrencyListRepository.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

struct CurrencyListRepository: Repositable {
    static let shared = CurrencyListRepository(storage: StorageManager.shared)

    let storage: StorageManager
    var prefixKey: RepositoryPrefixKey { return .currencyList }

    struct DataValue: StorageDataValue {
        let list: [CurrencyEntity]
    }

    private init(storage: StorageManager) {
        self.storage = storage
    }

    func get() -> (lastSavedDate: Date, value: CurrencyListRepository.DataValue)? {
        return get(key: prefixKey.rawValue)
    }

    func set(value: CurrencyListRepository.DataValue) {
        set(key: prefixKey.rawValue, value: value)
    }
}
