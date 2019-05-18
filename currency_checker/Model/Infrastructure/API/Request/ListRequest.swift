//
//  ListRequest.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import APIKit

struct ListRequest: CurrencylayerAPIRequest {
    typealias Response = CurrencyListDTO
    
    var path: String { return "/list" }
    
    var parameters: Any? {
        return ["access_key": accessKey]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> CurrencyListDTO {
        return try CurrencyListDTO(object: object)
    }
}
