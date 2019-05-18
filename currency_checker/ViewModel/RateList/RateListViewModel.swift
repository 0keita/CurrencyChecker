//
//  ViewModel.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation
import APIKit

final class RateListViewModel {
    private var loadingState = LoadingState.waiting {
        didSet {
            listener?.updateViewState(loadingState: loadingState)
        }
    }
    
    var selectedPickerViewModel: RateListPickerSelectViewModel? {
        didSet {
            guard let selectedPickerViewModel = selectedPickerViewModel else { return }
            
            listener?.didSelectCurrency(selected: selectedPickerViewModel)
            switch selectedPickerViewModel {
            case .currency(let entity):
                fetchRateList(currency: entity)
            }
        }
    }
    
    let pickerViewModels: [RateListPickerSelectViewModel]
    private(set) var cellViewModels = [RateListCellViewModel]() {
        didSet {
            listener?.updatedRateListCellViewModels()
        }
    }
    
    weak var listener: RateListViewModelListener?
    
    private let repository: RateListRepository
    
    init(repository: RateListRepository, entities: [CurrencyEntity]) {
        self.repository = repository
        self.pickerViewModels = entities.map { .currency($0) }
    }
    
    private func fetchRateList(currency: CurrencyEntity) {
        guard !loadingState.isLoading else { return }
        
        loadingState = .loading
        
        let requestService = RateListAPIRequestService(repository: repository)
        requestService.send(currency: currency.key) { [weak self] result in
            guard let wself = self else { return }
            
            switch result {
            case .success(let entities):
                wself.loadingState = .finished
                wself.cellViewModels = entities.map { RateListCellViewModel(entity: $0) }
                wself.saveResult(key: currency.key, by: entities)
            case .failure(let error):
                wself.loadingState = .error
                print("error: \(error)")
            }
        }
    }
    
    private func saveResult(key: String, by entities: [RateEntity]) {
        let data = RateListRepository.Data(list: entities)
        repository.set(key: key, data: data)
    }
}

protocol RateListViewModelListener: AnyObject {
    func updatedRateListCellViewModels()
    func didSelectCurrency(selected: RateListPickerSelectViewModel)
    func updateViewState(loadingState: LoadingState)
}
