//
//  RateListPickerSelectViewModel.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

enum RateListPickerSelectViewModel {
    case currency(entity: CurrencyEntity)

    var title: String {
        switch self {
        case .currency(let entity):
            return entity.key
        }
    }
}
