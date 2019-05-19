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
    func testGetAndSet() {
        let repository = RateListRepository.shared
        let key = "test"
        
        XCTAssertNil(repository.get(key: key), "RateListRepository should be empty")
        let sampleEntity = RateEntity(title: "test", value: 1)
        repository.set(key: key, data: RateListRepository.Data(list: [sampleEntity]))
        
        guard let data = repository.get(key: key) else {
            XCTFail("Data is not saved")
            return
        }
        
        XCTAssertEqual(data.data.list.count, 1)
        guard let savedEntity = data.data.list.first else { preconditionFailure() }
        
        XCTAssertEqual(savedEntity.title, sampleEntity.title)
        XCTAssertEqual(savedEntity.value, sampleEntity.value)
    }
}
