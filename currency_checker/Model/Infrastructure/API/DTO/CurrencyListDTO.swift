//
//  CurrencyListDTO.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation
import APIKit

struct CurrencyListDTO {
    let list: [CurrencyDTO]
    
    init(list: [CurrencyDTO]) {
        self.list = list
    }
    
    init(object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let currenciesDictionary = dictionary["currencies"] as? [String: String] else {
                throw ResponseError.unexpectedObject(object)
        }
        
        list = currenciesDictionary.map { CurrencyDTO(key: $0.key, name: $0.value) }
    }
}
