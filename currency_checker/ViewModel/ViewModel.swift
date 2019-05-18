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
    
    private let quotesRepository: QuotesRepository
    private let currencyListRepository: CurrencyListRepository
    
    init(quotesRepository: QuotesRepository, currencyListRepository: CurrencyListRepository) {
        self.quotesRepository = quotesRepository
        self.currencyListRepository = currencyListRepository
    }
    
    func fetchCurrencyList() {
        guard !loadingState.isLoading else { return }
        
        loadingState = .loading
        let requestService = CurrencyListAPIRequestService(repository: currencyListRepository)
        requestService.send { [weak self] result in
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
        // TODO: loadingState
        
        let requestService = QuoteAPIRequestService(repository: quotesRepository)
        requestService.send(currency: currency.key) { [weak self] result in
            guard let wself = self else { return }
            
            switch result {
            case .success(let dto):
                wself.cellViewModels = dto.list.map { CellViewModel(dto: $0) }
                wself.saveResult(key: currency.key, by: dto)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    private func saveResult(by dto: CurrencyListDTO) {
        let list = dto.list.map { CurrencyListRepository.Currency(key: $0.key, name: $0.name) }
        let data = CurrencyListRepository.Data(list: list)
        currencyListRepository.set(data: data)
    }
    
    private func saveResult(key: String, by dto: QuoteListDTO) {
        let list = dto.list.map { QuotesRepository.Quote(title: $0.title, rate: $0.rate) }
        let data = QuotesRepository.Data(list: list)
        quotesRepository.set(key: key, data: data)
    }
}

protocol ViewModelListener: AnyObject {
    func didSetCurrencies()
    func updatedCellViewModels()
    func didSelectCurrency(selected: CurrencyDTO)
    func displayAlert(message: String)
    func toggleIndicator(display: Bool)
}
