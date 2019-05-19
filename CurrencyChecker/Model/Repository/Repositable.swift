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
    associatedtype Data: StorageData
    static var shared: Self { get }
    var storage: Storage { get }
    func get(key: String) -> (lastSavedDate: Date, data: Data)?
    func set(key: String, data: Data)
}

extension Repositable {
    func get(key: String) -> (lastSavedDate: Date, data: Data)? {
        let storageKey = safeKey(with: key)
        guard let savedData = storage.get(key: storageKey) else { return nil }
        guard let value = savedData.value as? Data else { return nil }

        return (lastSavedDate: savedData.lastSavedDate, data: value)
    }

    func set(key: String, data: Data) {
        let storageKey = safeKey(with: key)
        storage.save(key: storageKey, value: data)
    }

    private func safeKey(with key: String) -> String {
        return "\(Self.self)-\(key)"
    }
}
