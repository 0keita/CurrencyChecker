//
//  CellViewModel.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

enum CellViewModel {
    case quote(dto: QuoteDTO)
    
    init(dto: QuoteDTO) {
        self = .quote(dto: dto)
    }
}
