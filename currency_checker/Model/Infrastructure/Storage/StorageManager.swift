//
//  StorageManager.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/18.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

final class StorageManager: Storageable {
    static let shared = StorageManager()
    
    typealias Data = (lastSavedDate: Date, value: StorageData)
    
    private(set) var list = [String: Data]()
    
    private init() {}
    
    func get(key: String) -> Data? {
        return list.first(where: { $0.key == key })?.value
    }
    
    func save(key: String, value data: StorageData) {
        list[key] = (lastSavedDate: Date(), value: data)
    }
}

protocol StorageData {
}
