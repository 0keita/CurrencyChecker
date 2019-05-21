//
//  CurrencyListRepositoryTests.swift
//  CurrencyCheckerTests
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import XCTest
@testable import CurrencyChecker

class CurrencyListRepositoryTests: XCTestCase {
    func testGetAndSet() {
        let repository = CurrencyListRepository.shared
        let key = "test"
        
        XCTAssertNil(repository.get(key: key), "CurrencyListRepository should be empty")
        let sampleEntity = CurrencyEntity(key: "USD", name: "USA Doller")
        repository.set(key: key, data: CurrencyListRepository.DataValue(list: [sampleEntity]))
        
        guard let data = repository.get(key: key) else {
            XCTFail("Data is not saved")
            return
        }
        
        XCTAssertEqual(data.data.list.count, 1)
        guard let savedEntity = data.data.list.first else { preconditionFailure() }
        
        XCTAssertEqual(savedEntity.key, sampleEntity.key)
        XCTAssertEqual(savedEntity.name, sampleEntity.name)
    }
}
