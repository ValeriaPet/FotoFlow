//
//  File.swift
//  FotoFlow
//
//  Created by LERÄ on 09.04.24.
//

import UIKit

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    func showAlert(title: String, message: String, handler: @escaping() -> Void
    ){
        DispatchQueue.main.async { [weak delegate] in
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
                    handler()
                }
                alert.addAction(alertAction)
            delegate?.present(alert, animated: true)
            }
        }
    }

