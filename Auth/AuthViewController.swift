//
//  AuthViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 17.01.24.
//

import UIKit

final class AuthViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var openButton: UIButton!
    private let WebViewId: String = "ShowWebView"

}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}
