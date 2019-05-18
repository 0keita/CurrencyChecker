//
//  RateListCellViewModel.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

enum RateListCellViewModel {
    case rate(entity: RateEntity)

    init(entity: RateEntity) {
        self = .rate(entity: entity)
    }
}
