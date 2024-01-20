//
//  WebViewViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 17.01.24.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    @IBAction private func didTapBackButton(_ sender: Any) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlComponents = URLComponents(string: "https://api.unsplash.com/")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6jDFSnen7ZD50h-6Hvjub-3AvzVJlIgObbHfJY1o6B8"),
            URLQueryItem(name: "redirect_uri", value: "urn:ietf:wg:oauth:2.0:oob"),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "public+read_user+write_likes")]
        
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)    }
}
