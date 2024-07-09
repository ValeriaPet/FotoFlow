
@testable import FotoFlow
import XCTest

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var logoutIsInitiated: Bool = false
    func profileLogout() {
        logoutIsInitiated.toggle()
    }
    func userImageUrlUpdateMonitor() {}
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    func viewDidLoad() {
        viewDidLoadCalled.toggle()
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var logoutAlert: UIAlertController?
    
    var exitButton: UIButton?
    var profileImageDidSet: Bool = false
    func updateAvatar(url: URL) {
        profileImageDidSet.toggle()
    }
    var configureUIElementsCalled: Bool = false
    var presenter: ProfilePresenterProtocol?
    var profileImageView: UIImageView?
    
    func UIElements(name: String, nick: String, greet: String){
        configureUIElementsCalled.toggle()
    }
    
}

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsConfigureUIElements() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.configureUIElementsCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                        object: self,
                                        userInfo: ["URL": Constants.DefaultBaseURL ?? ""])
        
        XCTAssertTrue(viewController.profileImageDidSet)
    }
    
    func testLogoutButtonAction() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.UIElements(name: "User", nick: "User", greet: "")
        viewController.exitButton?.sendActions(for: .allTouchEvents)
        
        let alert = viewController.logoutAlert
        XCTAssertTrue(alert != nil)
    }
}

