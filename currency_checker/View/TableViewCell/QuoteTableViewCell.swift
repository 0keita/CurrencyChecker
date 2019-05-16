//
//  QuoteTableViewCell.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/17.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import UIKit

final class QuoteTableViewCell: UITableViewCell {
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
    
    func fill(with quote: QuoteDTO) {
        nameLabel.text = quote.title
        rateLabel.text = String(quote.rate)
    }
}
