//
//  RateListRequest.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

struct RateListRequest: CurrencylayerAPIRequest {
    typealias Response = RateListDTO

    var path: String { return "/live" }

    var parameters: Any? {
        return [
            "access_key": accessKey,
            "source": source
        ]
    }

    let source: String

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> RateListDTO {
        return try RateListDTO(object: object)
    }
}
