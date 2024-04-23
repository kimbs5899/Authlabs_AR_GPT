//
//  UIViewController+Extension.swift
//  Authlabs_App
//
//  Created by Matthew on 4/22/24.
//

import UIKit

extension UIViewController {
    func showMessageAlert(
        title: String? = nil,
        message: String,
        action: [UIAlertAction],
        completion: (() -> ())? = nil
    ) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for result in action {
            alertViewController.addAction(result)
        }
        
        self.present(alertViewController, animated: true, completion: completion)
    }
}
