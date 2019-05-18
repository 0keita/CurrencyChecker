//
//  QuoteAPIRequestService.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/18.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation
import APIKit

struct QuoteAPIRequestService {
    enum Result {
        case success(entities: [QuoteEntity])
        case failure(error: Error)
    }
    
    let repository: QuotesRepository
    private let cacheIntervalTime = APIRequestService.Constant.cacheIntervalTime
    
    func send(currency: String, onResult: @escaping ((Result) -> Void)) {
        if let cacheData = repository.get(key: currency),
            cacheData.lastSavedDate.addingTimeInterval(cacheIntervalTime) > Date() {
            onResult(.success(entities: cacheData.data.list))
            return
        }
        
        let request = QuoteRequest(source: currency)
        
        Session.send(request) { result in
            switch result {
            case .success(let dto):
                let entities = dto.list.map { QuoteEntity(title: $0.title, rate: $0.rate) }
                onResult(.success(entities: entities))
            case .failure(let error):
                onResult(.failure(error: error))
            }
        }
    }
}
