//
//  UIViewControllerExtension.swift
//  currency_checker
//
//  Created by Keita Yoshida on 2019/05/19.
//  Copyright © 2019 Keita Yoshida. All rights reserved.
//

import UIKit

extension UIViewController {
    static func initializeFromStoryboard<T>() -> T {
        let storyBoardName = "\(T.self)".delete(suffix: "ViewController")
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        guard let viewController = storyBoard.instantiateInitialViewController() as? T else { preconditionFailure() }
        return viewController
    }
}
