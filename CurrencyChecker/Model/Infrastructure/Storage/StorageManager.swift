//
//  StorageManager.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/18.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

final class StorageManager: Storageable {
    static let shared = StorageManager()

    private init() {}

    private let userDefaults = UserDefaults.standard

    func get(key: String) -> StorageElement? {
        guard let encodedData = userDefaults.data(forKey: key) else { return nil }
        guard let element = try? JSONDecoder().decode(StorageElement.self, from: encodedData) else { return nil }
        return element
    }

    func save(key: String, value: Data) -> Bool {
        let element = StorageElement(lastSavedDate: Date(), value: value)
        guard let encodedElement = try? JSONEncoder().encode(element) else { return false }

        userDefaults.set(encodedElement, forKey: key)
        return userDefaults.synchronize()
    }

    func delete(key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
