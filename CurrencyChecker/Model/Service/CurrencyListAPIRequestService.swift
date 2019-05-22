//
//  CurrencyListAPIRequestService.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation
import APIKit

struct CurrencyListAPIRequestService {
    enum Result {
        case success(entities: [CurrencyEntity])
        case failure(error: Error)
    }

    let repository: CurrencyListRepository
    private let cacheIntervalTime = APIRequestService.Constant.cacheIntervalTime

    func send(handler: @escaping ((Result) -> Void)) {
        if let cacheData = repository.get(),
            cacheData.lastSavedDate.addingTimeInterval(cacheIntervalTime) > Date() {
            handler(.success(entities: cacheData.value.list))
            return
        }

        let request = CurrencyListRequest()

        APIRequestSeesion.shared.send(request) { result in
            switch result {
            case .success(let dto):
                let entities = dto.list.map { CurrencyEntity(key: $0.key, name: $0.name) }
                let value = CurrencyListRepository.DataValue(list: entities)
                if !self.repository.save(value: value) {
                    print("CurrencyListRepository Error: \(value)")
                }
                handler(.success(entities: entities))
            case .failure(let error):
                handler(.failure(error: error))
            }
        }
    }
}
