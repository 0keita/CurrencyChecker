//
//  RateListRepositoryTests.swift
//  CurrencyCheckerTests
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import XCTest
@testable import CurrencyChecker

class RateListRepositoryTests: XCTestCase {
    private let repository = RateListRepository.shared
    private let key = "test"
    
    override func setUp() {
        super.setUp()
        
        repository.delete(key: key)
    }
    
    func testGetAndSet() {
        XCTAssertNil(repository.get(key: key), "RateListRepository should be empty")
        let sampleEntity = RateEntity(title: "test", value: 1)
        _ = repository.save(key: key, value: RateListRepository.DataValue(list: [sampleEntity]))
        
        guard let data = repository.get(key: key) else {
            XCTFail("Data is not saved")
            return
        }
        
        XCTAssertEqual(data.value.list.count, 1)
        guard let savedEntity = data.value.list.first else { preconditionFailure() }
        
        XCTAssertEqual(savedEntity.title, sampleEntity.title)
        XCTAssertEqual(savedEntity.value, sampleEntity.value)
    }
}
