//
//  ViewModel.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation
import APIKit

final class ViewModel {
    private var loadingState = LoadingState.waiting {
        didSet {
            switch loadingState {
            case .error:
                listener?.toggleIndicator(display: false)
                listener?.displayAlert(message: "通信エラーが発生しました。\n再度お試しください。")
            case .finished:
                listener?.toggleIndicator(display: false)
            case .loading:
                listener?.toggleIndicator(display: true)
            case .waiting:
                break
            }
        }
    }
    
    var selectedCurrency: CurrencyDTO? {
        didSet {
            guard let selectedCurrency = selectedCurrency else { return }
            
            listener?.didSelectCurrency(selected: selectedCurrency)
        }
    }
    
    private(set) var currencies = [CurrencyDTO]() {
        didSet {
            listener?.didSetCurrencies()
        }
    }
    
    weak var listener: ViewModelListener?
    
    func fetchCurrencyList() {
        guard !loadingState.isLoading else { return }
        
        loadingState = .loading
        let request = ListRequest()
        
        Session.send(request) { [weak self] result in
            guard let wself = self else { return }
            
            switch result {
            case .success(let dto):
                wself.currencies = dto.list
                wself.loadingState = .finished
            case .failure(let error):
                print("error: \(error)")
                
                wself.loadingState = .error
            }
        }
    }
}

protocol ViewModelListener: AnyObject {
    func didSetCurrencies()
    func didSelectCurrency(selected: CurrencyDTO)
    func displayAlert(message: String)
    func toggleIndicator(display: Bool)
}
