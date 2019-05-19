//
//  RateTableViewCell.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import UIKit

final class RateTableViewCell: UITableViewCell {
    static let height = CGFloat(60)

    @IBOutlet private weak var nameLabel: UILabel!

    @IBOutlet private weak var rateLabel: UILabel! {
        didSet {
            rateLabel.textAlignment = .right
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    func fill(with rate: RateEntity) {
        nameLabel.text = rate.title
        rateLabel.text = String(rate.value)
    }
}
