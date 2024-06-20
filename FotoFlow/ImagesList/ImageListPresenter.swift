

import Foundation
import UIKit

protocol ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol? {get set}
    func viewDidLoad()
    func cleanPhotos()
    func getPhotosCount() -> Int
    func changeLike (for indexPath: IndexPath, completion: @escaping (Bool) -> Void)
    func getCellHeight (indexPath: IndexPath, tableBoundWidth: CGFloat) -> CGFloat
    func prepareNewCell (for tableView: UITableView, with indexpath: IndexPath, on viewController: ImagesListCellDelegate) -> UITableViewCell
}

final class ImageListPresenter: ImageListPresenterProtocol {
    
    weak var view: ImageListViewControllerProtocol?
    let imagesListService = ImagesListService.imagesListService
    let cellImageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    
    private let dateToStringFormatter = DateFormatter()
    private var photoNames: [Photo] = []
    private var ImagesListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        dateToStringFormatter.dateFormat = "dd MMMM yyyy"
        photoNames = imagesListService.photos
        
        ImagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.imageListUpdated,
            object: nil,
            queue: .main
        ) {[weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
    
    func cleanPhotos() {
        photoNames.removeAll()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photoNames.count
        let newCount = imagesListService.photos.count
        photoNames = imagesListService.photos
        if oldCount != newCount {
            self.view?.updateTableViewAnimated(with: oldCount..<newCount)
        }
    }
    
    func getPhotosCount() -> Int {
        return photoNames.count
    }
    
    func getSingleImageUrl(for row: Int) -> URL {
        return photoNames[row].largeImageURL
    }
    
    func changeLike(for indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        view?.activityIndicator(show: true)
        imagesListService.changeLike(photoId: indexPath.row) {[weak self] result in
            self?.view?.activityIndicator(show: false)
            switch result {
            case .success(let like):
                guard let favoriteImage = UIImage(named: like ? "LikeIsActive" : "LikeNoActive") else {
                    return
                }
                completion(like)
                print("CONSOLE func changeLike: изменен лайк для фото",
                      self?.photoNames[indexPath.row].id ?? "",
                      self?.photoNames[indexPath.row].welcomeDescription ?? "")
            case .failure(let error):
                print("CONSOLE func changeLike:", error.localizedDescription)
                
            }
        }
    }
    
    func getCellHeight(indexPath: IndexPath, tableBoundWidth: CGFloat) -> CGFloat {
        guard photoNames.count > 0 else {
            return 0
        }
        let imageViewWidth = tableBoundWidth - cellImageInsets.left - cellImageInsets.right
        let imageWidth = photoNames[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photoNames[indexPath.row].size.height * scale + cellImageInsets.top + cellImageInsets.bottom
        return cellHeight
    }
    
    func prepareNewCell(for tableView: UITableView, with indexpath: IndexPath, on viewController: any ImagesListCellDelegate) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexpath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = viewController
        let photo = photoNames[indexpath.row]
        imageListCell.configure(
            with: photo.thumbImageURL,
            date: dateToStringFormatter.string(from: photo.createdAt ?? Date()),
            isLiked: photo.isLiked) {[weak tableView] in
                tableView?.reloadRows(at: [indexpath], with: .automatic)
            }
        if indexpath.row == self.photoNames.count - 2, imagesListService.task == nil {
            print("CONSOLE func tableView: Достигнут конец ленты")
            self.imagesListService.fetchPhotosNextPage("") { }
        }
        return imageListCell
    }
}
