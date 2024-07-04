
import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? {get set}
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
        dismiss(animated: true, completion: nil)
    }
    var presenter: WebViewPresenterProtocol?
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "WebViewViewController"
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: {[weak self] _, _ in
                 guard self != nil else {return}
             })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    
//    extension WebViewViewController: WKNavigationDelegate {
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
                print("no")
            } else {
                decisionHandler(.allow)
                print("yes")
            }
        }
    
    
   private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
            return nil
        }
    }

