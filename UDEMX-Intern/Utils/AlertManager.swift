//
//  AlertManager.swift
//  UDEMX-Intern
//
//  Created by István Juhász on 2023. 02. 17..
//

import UIKit

class AlertManager {
    private static func showBasicAlert(on VC: UIViewController, with title: String, and message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            VC.present(alert, animated: true)
        }
    }
}

// MARK: - Show Validation Alerts
extension AlertManager {
    public static func showOnlyDismissAlert(on VC: UIViewController, with title: String, and message: String?) {
        self.showBasicAlert(on: VC, with: title, and: message)
    }
}
