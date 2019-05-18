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
        case success(dto: QuoteListDTO)
        case failure(error: Error)
    }
    
    let repository: QuotesRepository
    private let cacheIntervalTime = TimeInterval(30 * 60)
    
    func send(currency: String, onResult: @escaping ((Result) -> Void)) {
        if let cacheData = repository.get(key: currency),
            cacheData.lastSavedDate.addingTimeInterval(cacheIntervalTime) > Date() {
            let dto = QuoteListDTO(list: cacheData.data.list.map { QuoteDTO(title: $0.title, rate: $0.rate) })
            onResult(.success(dto: dto))
        }
        
        let request = QuoteRequest(source: currency)
        
        Session.send(request) { result in
            switch result {
            case .success(let dto):
                onResult(.success(dto: dto))
            case .failure(let error):
                onResult(.failure(error: error))
            }
        }
    }
}
