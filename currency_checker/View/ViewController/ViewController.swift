//
//  ViewController.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
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
    
    private let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.listener = self
        viewModel.fetchCurrencyList()
    }
    
    @objc private func didTapDoneToolBarButton() {
        let currentRow = currencyPickerView.selectedRow(inComponent: 0)
        viewModel.selectedCurrency = viewModel.currencies[currentRow]
        currencySelectorTextField.endEditing(true)
    }
    
    @objc private func didTapCancelToolBarButton() {
        currencySelectorTextField.endEditing(true)
    }
}

// - MARK: ViewModelListener implement
extension ViewController: ViewModelListener {
    func didSelectCurrency(selected: CurrencyDTO) {
        currencySelectorTextField.text = selected.key
    }
    
    func updatedCellViewModels() {
        quotesTableView.reloadData()
    }
    
    func didSetCurrencies() {
        currencyPickerView.reloadAllComponents()
    }
    
    func displayAlert(message: String) {
        print("TODO: \(#function)")
    }
    
    func toggleIndicator(display: Bool) {
        print("TODO: \(#function)")
    }
}

// - MARK: UIPickerViewDelegate implement
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.currencies[row].key
    }
}

// - MARK: UIPickerViewDataSource implement
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.currencies.count
    }
}

// - MARK: UITableViewDataSource implement
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        switch cellViewModel {
        case .quote(let dto):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(QuoteTableViewCell.self)", for: indexPath) as! QuoteTableViewCell
            cell.fill(with: dto)
            return cell
        }
    }
}
