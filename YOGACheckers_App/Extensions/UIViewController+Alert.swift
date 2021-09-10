//
//  UIViewController+Alert.swift
//  HomeWork_Lesson_13
//
//  Created by Мария Манжос on 11.08.21.
//

import UIKit

extension UIViewController {
    @discardableResult
    func presentAlertController(with title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, isUsedTextField: Bool = false, actionButtons: UIAlertAction... ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        actionButtons.forEach{alert.addAction($0)}
        
        if isUsedTextField, preferredStyle == .alert {
            alert.addTextField{ _ in
                
            }
        }

        present(alert, animated: true, completion: nil)
        
        return alert
    }
}
