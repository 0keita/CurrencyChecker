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
            fetchQuoteList(currency: selectedCurrency)
        }
    }
    
    private(set) var currencies = [CurrencyDTO]() {
        didSet {
            listener?.didSetCurrencies()
        }
    }
    
    private(set) var cellViewModels = [CellViewModel]() {
        didSet {
            listener?.updatedCellViewModels()
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
    
    private func fetchQuoteList(currency: CurrencyDTO) {
        // TODO: 時間を見る
        if let localResult = QuotesStorage.shared.get(key: currency.key) {
            cellViewModels = localResult.map { CellViewModel(dto: $0) }
            return
        }
        
        // TODO: loadingState
        let request = QuoteRequest(source: currency.key)
        
        Session.send(request) { [weak self] result in
            guard let wself = self else { return }
            
            switch result {
            case .success(let dto):
                wself.cellViewModels = dto.list.map { CellViewModel(dto: $0) }
                QuotesStorage.shared.set(key: currency.key, quotes: dto.list)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}

protocol ViewModelListener: AnyObject {
    func didSetCurrencies()
    func updatedCellViewModels()
    func didSelectCurrency(selected: CurrencyDTO)
    func displayAlert(message: String)
    func toggleIndicator(display: Bool)
}
