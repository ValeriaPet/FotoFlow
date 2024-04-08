//
//  AuthViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 17.01.24.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAutenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    private let WebViewId: String = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WebViewId {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(WebViewId)") }
            webViewViewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
//    func webViewViewControllerNetworkError(_ vc: WebViewViewController) {
//        print("Сетевая ошибка обнаружена")
//        networkError()
//    }
//
//    func networkError() {
//        let alertController = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "ОК", style: .default) { (action) in
//        }
//        alertController.addAction(okAction)
//        self.dismiss(animated: true) { [weak self] in
//            self?.present(alertController, animated: true, completion: nil)
//        }
//    }
    
    func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAutenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

