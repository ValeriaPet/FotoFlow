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
    private var oauth2TokenStorage = OAuth2TokenStorage.token
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
//    private let alertPresenter = AlertPresenter()
    
    private let showLoginFlowSegueID = "ShowLoginFlow"
    

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
        if oauth2Service.isAuthenticated {
            UIBlockingProgressHUD.show()
            if let token = oauth2TokenStorage {
                fetchProfile(token)
            } else {
                switchToTabBarController()
            }
                    } else {
                        showAuthController()
                        }
            UIBlockingProgressHUD.dismiss()
        }
    

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
        
    func showLoginAlert(message: String) {
        let alert = UIAlertController(
            title: "Что-то пошло не так :(",
            message: "Не удалось войти в систему.",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
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
    
    func authViewController(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
    
    private func fetchProfile(_ token: String) {
        
        profileService.fetchProfile(token) { [weak self] result in
            
                guard let self = self else { return }
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(let profile):
                    // Store the fetched profile in ProfileService
                    self.profileService.profile = profile
                    self.switchToTabBarController()
                case .failure:
                    self.showLoginAlert(message: "Не удалось получить данные профиля")
                
            }
        }
    }
    
    func authViewController(_ vc: AuthViewController, didAutenticateWithCode code: String) {
        
            if let token = OAuth2TokenStorage.token {
                        fetchProfile(token)
                    } else {
                        showLoginAlert(message: "Не удалось получить токен")
                        print("no")
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



