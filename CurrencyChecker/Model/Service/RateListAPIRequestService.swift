//
//  RateAPIRequestService.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/18.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation
import APIKit

struct RateListAPIRequestService {
    enum Result {
        case success(entities: [RateEntity])
        case failure(error: Error)
    }

    let repository: RateListRepository
    private let cacheIntervalTime = APIRequestService.Constant.cacheIntervalTime

    func send(currency: String, handler: @escaping ((Result) -> Void)) {
        if let cacheData = repository.get(key: currency),
            cacheData.lastSavedDate.addingTimeInterval(cacheIntervalTime) > Date() {
            handler(.success(entities: cacheData.data.list))
            return
        }

        let request = RateListRequest(source: currency)

        APIRequestSeesion.shared.send(request) { result in
            switch result {
            case .success(let dto):
                let entities = dto.list.map { RateEntity(title: $0.title, value: $0.rate) }
                handler(.success(entities: entities))
            case .failure(let error):
                handler(.failure(error: error))
            }
        }
    }
}
