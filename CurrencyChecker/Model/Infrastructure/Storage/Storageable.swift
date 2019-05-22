//
//  Storageable.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/18.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

protocol Storageable {
    func get(key: String) -> StorageElement?
    func save(key: String, value: Data) -> Bool
    func delete(key: String)
}

struct StorageElement: Codable {
    let lastSavedDate: Date
    let value: Data
}
