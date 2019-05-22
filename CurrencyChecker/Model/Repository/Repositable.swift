//
//  Repositable.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/18.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

protocol Repositable {
    associatedtype Storage: Storageable
    associatedtype DataValue: Codable
    static var shared: Self { get }
    var storage: Storage { get }
    var prefixKey: RepositoryPrefixKey { get }
    func get(key: String) -> (lastSavedDate: Date, value: DataValue)?
    func save(key: String, value: DataValue) -> Bool
    func delete(key: String)
}

extension Repositable {
    func get(key: String) -> (lastSavedDate: Date, value: DataValue)? {
        let storageKey = safeKey(with: key)
        guard let savedData = storage.get(key: storageKey) else { return nil }
        guard let value = try? JSONDecoder().decode(DataValue.self, from: savedData.value) else { return nil }

        return (lastSavedDate: savedData.lastSavedDate, value: value)
    }

    func save(key: String, value: DataValue) -> Bool {
        guard let encodedData = try? JSONEncoder().encode(value) else { return false }

        let storageKey = safeKey(with: key)
        return storage.save(key: storageKey, value: encodedData)
    }

    func delete(key: String) {
        let storageKey = safeKey(with: key)
        storage.delete(key: storageKey)
    }

    private func safeKey(with key: String) -> String {
        return "\(prefixKey.rawValue)-\(key)"
    }
}
