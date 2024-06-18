
@testable import FotoFlow
import XCTest

//final class ImagesListServiceTests: XCTestCase {
//    func testFetchPhotos() {
//        let service = ImagesListService()
//        
//        let expectation = self.expectation(description: "Wait for Notification")
//        NotificationCenter.default.addObserver(
//            forName: ImagesListService.imageListUpdated,
//            object: nil,
//            queue: .main) { _ in
//                expectation.fulfill()
//            }
//        
//        service.fetchPhotosNextPage("username", 1)
//        wait(for: [expectation], timeout: 10)
//        
//        XCTAssertEqual(service.photos.count, 10)
//    }
//}

func testPresenterCallsLoadRequest() {
    //given
    let viewController = WebViewViewControllerSpy()
    let authHelper = AuthHelper()
    let presenter = WebViewPresenter(authHelper: authHelper)
    viewController.presenter = presenter
    presenter.view = viewController
    
    //when
    presenter.viewDidLoad()
    
    //then
    XCTAssertTrue(viewController.loadRequestCalled)
}

func testProgressHiddenWhenOne() {
    //given
    let authHelper = AuthHelper() //Dummy
    let presenter = WebViewPresenter(authHelper: authHelper)
    let progress: Float = 1.0
    
    //when
    let shouldHideProgress = presenter.shouldHideProgress(for: progress) // return value verification
    
    //then
    XCTAssertTrue(shouldHideProgress)
}
func testAuthHelperAuthURL() {
    //given
    let configuration = AuthConfiguration.standard
    let authHelper = AuthHelper(configuration: configuration)
    
    //when
    let url = authHelper.authURL()
    guard let urlString = url?.absoluteString else {
        XCTFail("lox")
        return
    }
    
    //then
    XCTAssertTrue(urlString.contains(configuration.AuthURLString))
    XCTAssertTrue(urlString.contains(configuration.AccessKey))
    XCTAssertTrue(urlString.contains(configuration.RedirectURI))
    XCTAssertTrue(urlString.contains("code"))
    XCTAssertTrue(urlString.contains(configuration.AccessScope))
}
func testCodeFromURL() {
    //given
    var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
    urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
    let url = urlComponents.url!
    let authHelper = AuthHelper()
    
    //when
    let code = authHelper.code(from: url)
    
    //then
    XCTAssertEqual(code, "test code")
}
