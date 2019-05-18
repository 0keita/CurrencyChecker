//
//  QuoteListCellViewModel.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

enum QuoteListCellViewModel {
    case quote(entity: QuoteEntity)
    
    init(entity: QuoteEntity) {
        self = .quote(entity: entity)
    }
}
