//
//  ViewController.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import UIKit

final class QuoteListViewController: UIViewController {
    @IBOutlet private weak var currencySelectorTextField: UITextField! {
        didSet {
            currencySelectorTextField.inputView = currencyPickerView
            currencySelectorTextField.inputAccessoryView = toolbar
        }
    }
    @IBOutlet private weak var quotesTableView: UITableView! {
        didSet {
            quotesTableView.rowHeight = QuoteTableViewCell.height
            quotesTableView.dataSource = self
            
            let nib = UINib(nibName: "\(QuoteTableViewCell.self)", bundle: nil)
            quotesTableView.register(nib, forCellReuseIdentifier: "\(QuoteTableViewCell.self)")
        }
    }
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 40)))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneToolBarButton))
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelToolBarButton))
        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: false)
        return toolbar
    }()
    
    private lazy var currencyPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private var viewModel: QuoteListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.listener = self
    }
    
    @objc private func didTapDoneToolBarButton() {
        let currentRow = currencyPickerView.selectedRow(inComponent: 0)
        viewModel.selectedPickerViewModel = viewModel.pickerViewModels[currentRow]
        currencySelectorTextField.endEditing(true)
    }
    
    @objc private func didTapCancelToolBarButton() {
        currencySelectorTextField.endEditing(true)
    }
}

extension QuoteListViewController {
    static func initilize(with entities: [CurrencyEntity]) -> QuoteListViewController {
        let viewController: QuoteListViewController = QuoteListViewController.initializeFromStoryboard()
        viewController.viewModel = QuoteListViewModel(
            repository: QuotesRepository.shared,
            entities: entities
        )
        return viewController
    }
}

// - MARK: QuoteListViewModelListener implement
extension QuoteListViewController: QuoteListViewModelListener {
    func didSelectCurrency(selected: QuoteListPickerSelectViewModel) {
        currencySelectorTextField.text = selected.title
    }
    
    func updatedQuoteListCellViewModels() {
        quotesTableView.reloadData()
    }
    
    func updateViewState(loadingState: LoadingState) {
        switch loadingState {
        case .waiting:
            quotesTableView.isHidden = true
        case .loading:
            quotesTableView.isHidden = true
        case .error:
            quotesTableView.isHidden = true
            // TODO: presentAlert and retry
        case .finished:
            quotesTableView.isHidden = false
        }
    }
}

// - MARK: UIPickerViewDelegate implement
extension QuoteListViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.pickerViewModels[row].title
    }
}

// - MARK: UIPickerViewDataSource implement
extension QuoteListViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.pickerViewModels.count
    }
}

// - MARK: UITableViewDataSource implement
extension QuoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        switch cellViewModel {
        case .quote(let entity):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(QuoteTableViewCell.self)", for: indexPath) as! QuoteTableViewCell
            cell.fill(with: entity)
            return cell
        }
    }
}
