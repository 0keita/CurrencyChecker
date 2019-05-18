//
//  RateListDTO.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation
import APIKit

struct RateListDTO {
    let list: [RateDTO]
    
    init(object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let quotesDictionary = dictionary["quotes"] as? [String: Double] else {
                throw ResponseError.unexpectedObject(object)
        }
        
        list = quotesDictionary.map { RateDTO(title: $0.key, rate: $0.value) }
    }
}
