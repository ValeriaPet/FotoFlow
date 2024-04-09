//
//  SplashViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 28.01.24.
//

import UIKit

final class SplashViewController: UIViewController{
    
    private let ShowAuthenticationScreen = "AutenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let alertPresenter = AlertPresenter()
    
    private let showLoginFlowSegueID = "ShowLoginFlow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        checkAuthStatus()
    }

    private func checkAuthStatus() {
        if oauth2Service.isAuthenticated {
            UIBlockingProgressHUD.show()
           switchToTabBarController()
        } else {
                showAuthController()
            }
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
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
           
            switch result {
            case .success(let token):
                self?.fetchProfile(token)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                self?.showLoginAlert(error: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    private func fetchProfile(_ token: String) {
        
        profileService.fetchProfile(token) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
               
            case .failure(let error):
                self.showLoginAlert(error: error)
            
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func fetchProfileImageURL(_ username: String) {
        UIBlockingProgressHUD.show()
        ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in }
        UIBlockingProgressHUD.dismiss()
    }
    
    private func showLoginAlert(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.alertPresenter.showAlert(title: "Что-то пошло не так :(", message: "Не удалось войти в систему,\(error.localizedDescription)") {
                self?.performSegue(withIdentifier: self?.showLoginFlowSegueID ?? "", sender: nil)
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreen {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreen)")}
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func authViewController(_ vc: AuthViewController, didAutenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
}


