//
//  UITableViewExtension.swift
//  CurrencyChecker
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(reuseCell: T.Type) {
        let className = "\(reuseCell)"
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else {
            preconditionFailure()
        }
        return cell
    }
}
