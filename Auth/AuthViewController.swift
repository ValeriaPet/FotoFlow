//
//  AuthViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 17.01.24.
//

import UIKit

enum CodingError: Error {
    case customError
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, _ token: String)
}

final class AuthViewController: UIViewController {
    
    private let WebViewId: String = "ShowWebView"
    private var oauth2TokenStorage = OAuth2TokenStorage.token
    
    weak var delegate: AuthViewControllerDelegate?
    
//    override func viewDidLoad() {
//         super.viewDidLoad()
//         oauth2Service = OAuth2Service()
//     }
    
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
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        OAuth2Service.oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let token):
                // Сохранение токена в Keychain
                self.oauth2TokenStorage = token
                // Уведомление делегата об успешной аутентификации
                self.delegate?.authViewController(self, token)
            case .failure(let error):
                // Показ алерта с ошибкой
                self.showLoginAlert(error: error)
                print("purr")
            }
        }
    }
    
    func showLoginAlert(error: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так :(",
            message: "Не удалось войти в систему.",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}



