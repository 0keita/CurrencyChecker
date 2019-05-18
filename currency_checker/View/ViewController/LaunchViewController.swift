//
//  LaunchViewController.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView! {
        didSet {
            indicatorView.startAnimating()
        }
    }
    
    private let viewModel = LaunchViewModel(repository: CurrencyListRepository.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.listener = self
        viewModel.launch()
    }
}

extension LaunchViewController: LaunchViewModelListener {
    func displayMainView(entities: [CurrencyEntity]) {
        let viewController = RateListViewController.initilize(with: entities)
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    func displayAlert(message: String) {
        let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            guard let wself = self else { return }
            wself.viewModel.retry()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func toggleIndicator(display: Bool) {
        if display {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
    }
}
