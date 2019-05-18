//
//  CurrencyListAPIRequestService.swift
//  currency_checker
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
    
    func send(onResult: @escaping ((Result) -> Void)) {
        if let cacheData = repository.get(),
            cacheData.lastSavedDate.addingTimeInterval(cacheIntervalTime) > Date() {
            onResult(.success(entities: cacheData.data.list))
            return
        }
        
        let request = CurrencyListRequest()
        
        Session.send(request) { result in
            switch result {
            case .success(let dto):
                let entities = dto.list.map { CurrencyEntity(key: $0.key, name: $0.name) }
                onResult(.success(entities: entities))
            case .failure(let error):
                onResult(.failure(error: error))
            }
        }
    }
}
