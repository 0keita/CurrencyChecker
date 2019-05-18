//
//  RateListRepository.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

struct RateListRepository: Repositable {
    static let shared = RateListRepository(storage: StorageManager.shared)

    let storage: StorageManager

    struct Data: StorageData {
        let list: [RateEntity]
    }

    private init(storage: StorageManager) {
        self.storage = storage
    }
}
