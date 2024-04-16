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
    private var oauth2Service: OAuth2Service?
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
         super.viewDidLoad()
         oauth2Service = OAuth2Service()
     }
    
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
    
    func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAutenticateWithCode: code)
        oauth2Service?.fetchOAuthToken(code, completion: { [weak self] result in
            switch result {
            case .success(let token):
                print("Token received: \(token)")
            case .failure(let error):
                self?.showLoginAlert(error: error)
            }
        })
    }
    func showLoginAlert(error: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так :(",
            message: "Не удалось войти в систему. Ошибка: \(error.localizedDescription)",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}



