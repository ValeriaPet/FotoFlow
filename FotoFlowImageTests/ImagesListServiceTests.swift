
@testable import FotoFlow
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.imageListUpdated,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotosNextPage("username", 1)
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 1)
    }
}
