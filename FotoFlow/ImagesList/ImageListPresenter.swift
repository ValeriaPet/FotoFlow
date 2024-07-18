

import Foundation
import UIKit

protocol ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol? {get set}
    func viewDidLoad()
    func cleanPhotos()
    func getPhotosCount() -> Int
    func singleImageURL(for row: Int) -> URL
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
    
    func singleImageURL(for row: Int) -> URL {
        return photoNames[row].largeImageURL
    }
    
    func changeLike(for indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        view?.activityIndicator(show: true)
        imagesListService.changeLike(photoId: indexPath.row) {[weak self] result in
            self?.view?.activityIndicator(show: false)
            switch result {
            case .success(let like):
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
        
        // Настройка изображения с помощью Kingfisher
        imageListCell.cellImage.kf.indicatorType = .activity
        imageListCell.cellImage.kf.setImage(
            with: photo.thumbImageURL,
            placeholder: UIImage(named: "picture_load_placeholder")
        ) {[weak tableView] _ in
            tableView?.reloadRows(at: [indexpath], with: .automatic)
        }
        
        // Настройка даты
        imageListCell.dataText.text = dateToStringFormatter.string(from: photo.createdAt ?? Date())
        
        // Настройка кнопки лайка
        let likedImage = UIImage(named: photo.isLiked ? "LikeIsActive" : "LikeNoActive")
        imageListCell.likeButton.setImage(likedImage, for: .normal)
        
        // Настройка градиента
        imageListCell.gradientView.layer.masksToBounds = true
        imageListCell.gradientView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        imageListCell.gradientView.layer.cornerRadius = 16
        let gradient = CAGradientLayer()
        gradient.frame = imageListCell.gradientView.bounds
        gradient.colors = [UIColor.igGradientAlpha0.cgColor, UIColor.igGradientAlpha20.cgColor]
        imageListCell.gradientView.layer.insertSublayer(gradient, at: 0)
        
        if indexpath.row == self.photoNames.count - 2, imagesListService.task == nil {
            print("CONSOLE func tableView: Достигнут конец ленты")
            self.imagesListService.fetchPhotosNextPage("") { }
        }
        return imageListCell
    }

    
}
