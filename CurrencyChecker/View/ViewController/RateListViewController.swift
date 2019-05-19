//
//  ViewController.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import UIKit

final class RateListViewController: UIViewController {
    @IBOutlet private weak var currencySelectorTextField: UITextField! {
        didSet {
            currencySelectorTextField.inputView = currencyPickerView
            currencySelectorTextField.inputAccessoryView = toolbar
        }
    }
    @IBOutlet private weak var rateListTableView: UITableView! {
        didSet {
            rateListTableView.rowHeight = RateTableViewCell.height
            rateListTableView.dataSource = self

            rateListTableView.register(reuseCell: RateTableViewCell.self)
        }
    }

    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 40)))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done,
                                       target: self,
                                       action: #selector(didTapDoneToolBarButton))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                         target: self,
                                         action: #selector(didTapCancelToolBarButton))
        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: false)
        return toolbar
    }()

    private lazy var currencyPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    private var viewModel: RateListViewModel!

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

extension RateListViewController {
    static func initilize(with entities: [CurrencyEntity]) -> RateListViewController {
        let viewController: RateListViewController = RateListViewController.initializeFromStoryboard()
        viewController.viewModel = RateListViewModel(
            repository: RateListRepository.shared,
            entities: entities
        )
        return viewController
    }
}

// - MARK: RateListViewModelListener implement
extension RateListViewController: RateListViewModelListener {
    func didSelectCurrency(selected: RateListPickerSelectViewModel) {
        currencySelectorTextField.text = selected.title
    }

    func updatedRateListCellViewModels() {
        rateListTableView.reloadData()
    }

    func updateViewState(loadingState: LoadingState) {
        switch loadingState {
        case .waiting, .finished:
            rateListTableView.isHidden = false
            indicatorView.stopAnimating()
        case .loading:
            rateListTableView.isHidden = true
            indicatorView.startAnimating()
        case .error:
            rateListTableView.isHidden = true
            indicatorView.stopAnimating()
            // TODO: presentAlert and retry
        }
    }
}

// - MARK: UIPickerViewDelegate implement
extension RateListViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.pickerViewModels[row].title
    }
}

// - MARK: UIPickerViewDataSource implement
extension RateListViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.pickerViewModels.count
    }
}

// - MARK: UITableViewDataSource implement
extension RateListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        switch cellViewModel {
        case .rate(let entity):
            let cell = tableView.dequeueReusableCell(for: indexPath) as RateTableViewCell
            cell.fill(with: entity)
            return cell
        }
    }
}
