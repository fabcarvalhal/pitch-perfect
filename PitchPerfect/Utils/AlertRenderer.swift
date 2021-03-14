//
//  AlertRenderer.swift
//  PitchPerfect
//
//  Created by Fabrício Silva Carvalhal on 13/03/21.
//

import UIKit

class AlertRenderer {
    weak var controller: UIViewController?
    
    init(with controller: UIViewController) {
        self.controller = controller
    }
    
    func showSimpleAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertMessages.dismissAlert, style: .default, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
}
