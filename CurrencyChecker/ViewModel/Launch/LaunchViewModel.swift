//
//  LaunchViewModel.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import Foundation

final class LaunchViewModel {
    private var loadingState = LoadingState.waiting {
        didSet {
            listener?.updateViews(state: loadingState)
        }
    }

    weak var listener: LaunchViewModelListener?
    private let repository: CurrencyListRepository

    init(repository: CurrencyListRepository) {
        self.repository = repository
    }

    func launch() {
        fetchCurrencyList()
    }

    func retry() {
        fetchCurrencyList()
    }

    private func fetchCurrencyList() {
        guard !loadingState.isLoading else { return }

        loadingState = .loading
        let requestService = CurrencyListAPIRequestService(repository: repository)
        requestService.send { [weak self] result in
            guard let wself = self else { return }

            switch result {
            case .success(let entities):
                wself.loadingState = .finished
                wself.listener?.displayMainView(entities: entities)
            case .failure:
                wself.loadingState = .error
                wself.listener?.displayAlert(message: "通信エラーが発生しました。\n再度お試しください。")
            }
        }
    }
}

protocol LaunchViewModelListener: AnyObject {
    func displayMainView(entities: [CurrencyEntity])
    func displayAlert(message: String)
    func updateViews(state: LoadingState)
}
