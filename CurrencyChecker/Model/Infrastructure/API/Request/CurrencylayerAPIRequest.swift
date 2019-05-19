//
//  CurrencylayerAPIRequest.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import APIKit

protocol CurrencylayerAPIRequest: Request {
}

extension CurrencylayerAPIRequest {
    var accessKey: String { return "393d7e91eea017841fc9bf9fe784e94f" } // TODO: encrypt
    var baseURL: URL {
        guard let url = URL(string: "http://apilayer.net/api") else { preconditionFailure() }
        return url
    }
    var method: HTTPMethod { return .get }
}
