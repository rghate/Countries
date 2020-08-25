//
//  CustomAlert.swift
//  PolicyBuddy
//
//  Created by Rupali on 25/08/2020.

import UIKit

class CustomAlert {
    
    static func showAlert(withTitle title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
