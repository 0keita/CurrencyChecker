//
//  Storageable.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/18.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

protocol Storageable {
    typealias Element = (lastSavedDate: Date, value: StorageDataValue)

    var list: [String: Element] { get }

    func get(key: String) -> Element?
    func save(key: String, value: StorageDataValue)
}
