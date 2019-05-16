//
//  QuoteRequest.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

struct QuoteRequest: CurrencylayerAPIRequest {
    typealias Response = QuoteListDTO
    
    var path: String { return "/live" }
    
    var parameters: Any? {
        return [
            "access_key": accessKey,
            "source": "USD" // TODO
        ]
    }
    
    let source: String
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> QuoteListDTO {
        return try QuoteListDTO(object: object)
    }
}
