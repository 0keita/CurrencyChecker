//
//  LoadingState.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

enum LoadingState {
    case waiting, loading, error, finished
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        case .waiting, .error, .finished:
            return false
        }
    }
}
