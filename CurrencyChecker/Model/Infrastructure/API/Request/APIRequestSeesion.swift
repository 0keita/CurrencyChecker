//
//  APIRequestSeesion.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation
import APIKit

struct APIRequestSeesion {
    static let shared = APIRequestSeesion()

    private init() {}

    func send<Request: CurrencylayerAPIRequest>(
        _ request: Request,
        callbackQueue: APIKit.CallbackQueue? = nil,
        handler: @escaping (Result<Request.Response, APIKit.SessionTaskError>) -> Void = { _ in }) {
        Session.send(request, callbackQueue: callbackQueue) { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                print("APIError: \(failure)")
            }
            handler(result)
        }
    }
}
