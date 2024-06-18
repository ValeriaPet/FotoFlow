
import UIKit

enum CodingError: Error {
    case customError
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, _ token: String)
}

final class AuthViewController: UIViewController {
    
    private let WebViewId: String = "ShowWebView"
    private var oauth2TokenStorage = OAuth2TokenStorage.shared.token
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WebViewId {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { 
            fatalError("Failed to prepare for \(WebViewId)") }
            
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
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
                self.oauth2TokenStorage = token
                self.delegate?.authViewController(self, token)
            case .failure(let error):
                self.showLoginAlert(error: error)
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



