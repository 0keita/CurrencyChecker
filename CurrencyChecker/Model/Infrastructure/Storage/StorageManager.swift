//
//  StorageManager.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/18.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

// TODO: Persistence
final class StorageManager: Storageable {
    static let shared = StorageManager()

    private(set) var list = [String: Element]()

    private init() {}

    func get(key: String) -> Element? {
        return list.first(where: { $0.key == key })?.value
    }

    func save(key: String, value data: StorageDataValue) {
        list[key] = (lastSavedDate: Date(), value: data)
    }
}

protocol StorageDataValue {
}
