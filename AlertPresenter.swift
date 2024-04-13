//
//  File.swift
//  FotoFlow
//
//  Created by LERÄ on 09.04.24.
//

import UIKit

struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    var completion: ((UIAlertAction) -> Void)? = nil
}

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    static func showAlert(alert model: AlertModel, on screen: UIViewController) {
        let alert = UIAlertController(
            title: model.title,
            message: model.text,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(title: model.buttonText, style: .default, handler: model.completion)
        
        alert.addAction(alertAction)
        screen.present(alert, animated: true, completion: nil)
    }
}


