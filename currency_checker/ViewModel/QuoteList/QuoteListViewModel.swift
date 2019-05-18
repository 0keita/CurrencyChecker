//
//  ViewModel.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation
import APIKit

final class QuoteListViewModel {
    private var loadingState = LoadingState.waiting {
        didSet {
            listener?.updateViewState(loadingState: loadingState)
        }
    }
    
    var selectedCurrency: CurrencyDTO? {
        didSet {
            guard let selectedCurrency = selectedCurrency else { return }
            
            listener?.didSelectCurrency(selected: selectedCurrency)
            fetchQuoteList(currency: selectedCurrency)
        }
    }
    
    private(set) var currencies = [CurrencyDTO]()
    
    private(set) var cellViewModels = [QuoteListCellViewModel]() {
        didSet {
            listener?.updatedQuoteListCellViewModels()
        }
    }
    
    weak var listener: QuoteListViewModelListener?
    
    private let repository: QuotesRepository
    
    init(repository: QuotesRepository, currencyList: CurrencyListDTO) {
        self.repository = repository
        self.currencies = currencyList.list
    }
    
    private func fetchQuoteList(currency: CurrencyDTO) {
        guard !loadingState.isLoading else { return }
        
        loadingState = .loading
        
        let requestService = QuoteAPIRequestService(repository: repository)
        requestService.send(currency: currency.key) { [weak self] result in
            guard let wself = self else { return }
            
            switch result {
            case .success(let dto):
                wself.loadingState = .finished
                wself.cellViewModels = dto.list.map { QuoteListCellViewModel(dto: $0) }
                wself.saveResult(key: currency.key, by: dto)
            case .failure(let error):
                wself.loadingState = .error
                print("error: \(error)")
            }
        }
    }
    
    private func saveResult(key: String, by dto: QuoteListDTO) {
        let list = dto.list.map { QuotesRepository.Quote(title: $0.title, rate: $0.rate) }
        let data = QuotesRepository.Data(list: list)
        repository.set(key: key, data: data)
    }
}

protocol QuoteListViewModelListener: AnyObject {
    func updatedQuoteListCellViewModels()
    func didSelectCurrency(selected: CurrencyDTO)
    func updateViewState(loadingState: LoadingState)
}
