//
//  Storageable.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/18.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

protocol Storageable {
    typealias Data = (lastSavedDate: Date, value: StorageData)

    var list: [String: Data] { get }

    func get(key: String) -> Data?
    func save(key: String, value: StorageData)
}
