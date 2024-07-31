
@testable import FotoFlow
import XCTest

final class ImagesListViewControllerSpy: ImageListViewControllerProtocol {
    var updateTableViewAnimatedIsCalled = false
    var presenter: ImageListPresenterProtocol?
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
    func updateTableViewAnimated(with rangeOfCells: Range<Int>) {
        updateTableViewAnimatedIsCalled.toggle()
    }
    func activityIndicator(show: Bool) { }
}

final class ImagesListPresenterSpy: ImageListPresenterProtocol {
    var viewDidLoadCalled = false
    var view: ImageListViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled.toggle()
    }
    func cleanPhotos() { }
    func getPhotosCount() -> Int {
        0
    }
    func singleImageURL(for row: Int) -> URL {
        return Constants.DefaultBaseURL!
    }
    func changeLike(for indexPath: IndexPath, completion: @escaping (Bool) -> Void) { }
    func getFavoriteButtonImage(for cellIndex: IndexPath) -> UIImage? {
        UIImage()
    }
    func getCellHeight(indexPath: IndexPath, tableBoundWidth: CGFloat) -> CGFloat {
        0
    }
    func prepareNewCell(for tableView: UITableView,
                        with indexPath: IndexPath,
                        on viewController: any FotoFlow.ImagesListCellDelegate) -> UITableViewCell {
        return UITableViewCell()
    }
}

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        
        viewController.viewDidLoad()
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testGetPhotoCount() {
        let presenter = ImageListPresenter()
        presenter.imagesListService.addMockPhotosForTests()
        presenter.viewDidLoad()
                
        XCTAssertEqual(presenter.getPhotosCount(), 5)
    }
    
    func testCleanPhotos() {
        let presenter = ImageListPresenter()
        presenter.imagesListService.addMockPhotosForTests()
        presenter.viewDidLoad()

        presenter.cleanPhotos()
        XCTAssertEqual(presenter.getPhotosCount() , 0)
    }
    
    func testUpdateTableViewAnimatedIsCalled() {
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImageListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()

        presenter.cleanPhotos()
        presenter.imagesListService.addMockPhotosForTests()
        NotificationCenter.default.post(name: ImagesListService.imageListUpdated,
                                        object: self)
        
        XCTAssert(viewController.updateTableViewAnimatedIsCalled)
    }
    
    func testGetSingleImageUrl() {
        let presenter = ImageListPresenter()
        presenter.imagesListService.addMockPhotosForTests()
        presenter.viewDidLoad()
        
        var singleImageUrl: URL?
        singleImageUrl = presenter.singleImageURL(for: 0)
        
        XCTAssert(singleImageUrl != nil)
    }
    
    func testGetCellHeight() {
        let presenter = ImageListPresenter()
        presenter.imagesListService.addMockPhotosForTests()
        presenter.viewDidLoad()
        let indexPath = IndexPath(row: 1, section: 0)
        let photoWidth = presenter.imagesListService.photos[indexPath.row].size.width
        let photoHeight = presenter.imagesListService.photos[indexPath.row].size.height
        let insets = presenter.cellImageInsets

        let cellHeight = presenter.getCellHeight(
            indexPath: indexPath,
            tableBoundWidth: photoWidth + insets.left + insets.right
        )
        
        XCTAssertEqual(cellHeight, photoHeight + insets.top + insets.bottom)
    }
}
