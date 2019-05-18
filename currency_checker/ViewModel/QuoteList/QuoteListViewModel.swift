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
    
    var selectedPickerViewModel: QuoteListPickerSelectViewModel? {
        didSet {
            guard let selectedPickerViewModel = selectedPickerViewModel else { return }
            
            listener?.didSelectCurrency(selected: selectedPickerViewModel)
            switch selectedPickerViewModel {
            case .currency(let entity):
                fetchQuoteList(currency: entity)
            }
        }
    }
    
    let pickerViewModels: [QuoteListPickerSelectViewModel]
    private(set) var cellViewModels = [QuoteListCellViewModel]() {
        didSet {
            listener?.updatedQuoteListCellViewModels()
        }
    }
    
    weak var listener: QuoteListViewModelListener?
    
    private let repository: QuotesRepository
    
    init(repository: QuotesRepository, entities: [CurrencyEntity]) {
        self.repository = repository
        self.pickerViewModels = entities.map { .currency($0) }
    }
    
    private func fetchQuoteList(currency: CurrencyEntity) {
        guard !loadingState.isLoading else { return }
        
        loadingState = .loading
        
        let requestService = QuoteAPIRequestService(repository: repository)
        requestService.send(currency: currency.key) { [weak self] result in
            guard let wself = self else { return }
            
            switch result {
            case .success(let entities):
                wself.loadingState = .finished
                wself.cellViewModels = entities.map { QuoteListCellViewModel(entity: $0) }
                wself.saveResult(key: currency.key, by: entities)
            case .failure(let error):
                wself.loadingState = .error
                print("error: \(error)")
            }
        }
    }
    
    private func saveResult(key: String, by entities: [QuoteEntity]) {
        let data = QuotesRepository.Data(list: entities)
        repository.set(key: key, data: data)
    }
}

protocol QuoteListViewModelListener: AnyObject {
    func updatedQuoteListCellViewModels()
    func didSelectCurrency(selected: QuoteListPickerSelectViewModel)
    func updateViewState(loadingState: LoadingState)
}
