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
    private let repository = CurrencyListRepository.shared
    private let key = "test"
    
    override func setUp() {
        super.setUp()
        
        repository.delete(key: key)
    }
    
    func testGetAndSet() {
        XCTAssertNil(repository.get(key: key), "CurrencyListRepository should be empty")
        let sampleEntity = CurrencyEntity(key: "USD", name: "USA Doller")
        _ = repository.save(key: key, value: CurrencyListRepository.DataValue(list: [sampleEntity]))
        
        guard let data = repository.get(key: key) else {
            XCTFail("Data is not saved")
            return
        }
        
        XCTAssertEqual(data.value.list.count, 1)
        guard let savedEntity = data.value.list.first else { preconditionFailure() }
        
        XCTAssertEqual(savedEntity.key, sampleEntity.key)
        XCTAssertEqual(savedEntity.name, sampleEntity.name)
    }
}
