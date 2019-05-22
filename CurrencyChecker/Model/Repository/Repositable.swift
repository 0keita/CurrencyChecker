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
    associatedtype DataValue: StorageDataValue
    static var shared: Self { get }
    var storage: Storage { get }
    var prefixKey: RepositoryPrefixKey { get }
    func get(key: String) -> (lastSavedDate: Date, value: DataValue)?
    func set(key: String, value: DataValue)
}

extension Repositable {
    func get(key: String) -> (lastSavedDate: Date, value: DataValue)? {
        let storageKey = safeKey(with: key)
        guard let savedData = storage.get(key: storageKey) else { return nil }
        guard let value = savedData.value as? DataValue else { return nil }

        return (lastSavedDate: savedData.lastSavedDate, value: value)
    }

    func set(key: String, value: DataValue) {
        let storageKey = safeKey(with: key)
        storage.save(key: storageKey, value: value)
    }

    private func safeKey(with key: String) -> String {
        return "\(prefixKey.rawValue)-\(key)"
    }
}
