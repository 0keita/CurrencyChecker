//
//  CurrencylayerAPIRequest.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import APIKit

// http://apilayer.net/api/list?access_key=9288c067cacdb7fe29aa5cbdacb28e73
protocol CurrencylayerAPIRequest: Request {
}

extension CurrencylayerAPIRequest {
    var accessKey: String { return "9288c067cacdb7fe29aa5cbdacb28e73" }
    var baseURL: URL { return URL(string: "http://apilayer.net/api")! }
    var method: HTTPMethod { return .get }
}
