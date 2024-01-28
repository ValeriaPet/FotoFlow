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
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var openButton: UIButton!
    private let WebViewId: String = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?

}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAutenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}
