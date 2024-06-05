
import Foundation

public protocol WebViewPresenterProtocol{
    var view: WebViewViewControllerProtocol? {get set}
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    private let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    func viewDidLoad() {
        
        guard var urlComponents = URLComponents(string: UnsplashAuthorizeURLString) else {return}
    
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)]
        
    guard let url = urlComponents.url else {return}
        let request = URLRequest(url: url)
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    func shouldHideProgress(for value: Float) -> Bool {
            abs(value - 1.0) <= 0.0001
        }
}
