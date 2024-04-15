//
//  SplashViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 28.01.24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let ShowAuthenticationScreen = "AutenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let alertPresenter = AlertPresenter()
    
    private let showLoginFlowSegueID = "ShowLoginFlow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIElementsLogo()
        alertPresenter.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        UIElementsLogo()
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
        if oauth2Service.isAuthenticated {
            UIBlockingProgressHUD.show()
           switchToTabBarController()
        } else {
                showAuthController()
            }
        UIBlockingProgressHUD.dismiss()
        }
    
//    private func showAuthController() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(identifier: "AuthViewControllerID") as UIViewController
//        viewController.modalPresentationStyle = .fullScreen
//        self.present(viewController, animated: true, completion: nil)
//    }

    private func showAuthController() {
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AuthViewControllerID")
        guard let authViewController = viewController as? AuthViewController else {return}
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(let token):
                    OAuth2TokenStorage.token = token
                    self?.fetchProfile(token)
                    
                case .failure:
                    self?.showLoginAlert(message: "Не удалось войти в систему")
                }
            }
        }
    }
  
    
    private func showLoginAlert(message: String) {
        let alert = UIAlertController(title: "Что-то пошло не так :(", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.showAuthController()
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func presentAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "AuthViewControllerID")
        guard let authViewController = viewController as? AuthViewController
        else {return}
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    private func fetchProfile(_ token: String) {
        
        profileService.fetchProfile(token) { [weak self] result in
            
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success:
                    self.switchToTabBarController()
                case .failure:
                    self.showLoginAlert(message: "Не удалось получить данные профиля")
                }
            }
        }
    }
    
    func authViewController(_ vc: AuthViewController, didAutenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func UIElementsLogo() {
        view.backgroundColor = .ypBackgroundIOS
        let logoImage = UIImage(named: "Logo_of_Unsplash")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}



