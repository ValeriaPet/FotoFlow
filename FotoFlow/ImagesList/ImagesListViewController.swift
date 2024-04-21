//
//import UIKit
//
//class ImagesListViewController: UIViewController {
//    
//    @IBOutlet private var tableView: UITableView!
//    
//    private let ShowSingleImageSegueId = "ShowSingleImage"
//    private var photoNames: [Photo] = []
//    private let imagesListService = ImagesListService.imagesListService
//    private var ImagesListServiceObserver: NSObjectProtocol?
//    private let dateToStringFormatter = DateFormatter()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
//        photoNames = imagesListService.photos
//        
//        dateToStringFormatter.dateFormat = "dd MMMM yyyy"
//        dateToStringFormatter.locale = Locale(identifier: "ru_RU")
//        
//        ImagesListServiceObserver = NotificationCenter.default.addObserver(
//            forName: ImagesListService.imageListUpdated,
//            object: nil,
//            queue: .main
//        ) {[weak self] _ in
//            self?.updateTableViewAnimated()
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier ==  ShowSingleImageSegueId {
//            if let viewController = segue.destination as? SingleImageViewController,
//            let indexPath = sender as? IndexPath {
//                viewController.imageURL = photoNames[indexPath.row].largeImageURL
//            } else {
//                super.prepare(for: segue, sender: sender)
//            }
//        }
//    }
//        
//    func updateTableViewAnimated() {
//        let oldCount = photoNames.count
//        let newCount = imagesListService.photos.count
//        photoNames = imagesListService.photos
//        if oldCount != newCount {
//            tableView.performBatchUpdates {
//                let indexPaths = (oldCount..<newCount).map { i in
//                    IndexPath(row: i, section: 0)
//                }
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            } completion: { _ in }
//        }
//    }
//    
//    func cleanPhotos() {
//        photoNames.removeAll()
//    }
//    
////    private lazy var dateFormatter: DateFormatter = {
////        let formatter = DateFormatter()
////        formatter.dateStyle = .long
////        formatter.timeStyle = .none
////        return formatter
////    }()
////}
//    private func setImageWithKF(for cell: ImagesListCell, with indexPath: IndexPath) {
//        cell.cellImage.kf.indicatorType = .activity
//        
//        cell.cellImage.kf.setImage(
//            with: photoNames[indexPath.row].thumbImageURL,
//            placeholder: UIImage(named: "picture_load_placeholder")
//        ) {[weak self] _ in
//            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//    }
//    
//    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
//        setImageWithKF(for: cell, with: indexPath)
//        cell.dataText.text = self.dateToStringFormatter.string(from: self.photoNames[indexPath.row].createdAt ?? Date())
//        
//        let likedImage = UIImage(named: self.photoNames[indexPath.row].isLiked ? "LikeActive" : "LikeNoActive")
//        cell.likeButton.setImage(likedImage, for: .normal)
//        
//        cell.gradientView.layer.masksToBounds = true
//        cell.gradientView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        cell.gradientView.layer.cornerRadius = 16
//        let gradient = CAGradientLayer()
//        gradient.frame = cell.gradientView.bounds
//        gradient.colors = [UIColor.igGradientAlpha0.cgColor, UIColor.igGradientAlpha20.cgColor]
//        cell.gradientView.layer.insertSublayer(gradient, at: 0)
//    }
//}
//
//extension ImagesListViewController: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return photoNames.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) 
//        
//        guard let imageListCell = cell as? ImagesListCell else {
//            return UITableViewCell()
//        }
//        
//        imageListCell.delegate = self
//        
//        configCell(for: imageListCell, with: indexPath)
//        
//        if indexPath.row == self.photoNames.count - 2, imagesListService.task == nil {
//            self.imagesListService.fetchPhotosNextPage("") {}
//        }
//        return imageListCell
//    }
//}
//
//
//extension ImagesListViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         performSegue(withIdentifier: ShowSingleImageSegueId, sender: indexPath)
//     }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard self.photoNames.count > 0 else {
//            return 0
//    }
//        let photoInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let photoViewWidth = tableView.bounds.width - photoInsets.left - photoInsets.right
//        let photoWidth = photoNames[indexPath.row].size.width
//        let scale = photoViewWidth / photoWidth
//        let cellHeight = photoNames[indexPath.row].size.height * scale + photoInsets.top + photoInsets.bottom
//        return cellHeight
//    }
//}
//
//extension ImagesListViewController: ImagesListCellDelegate {
//    func imageListCellDidTapLike(_ cell: ImagesListCell) {
//   
//    }
//}



import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let ShowSingleImageSegueId = "ShowSingleImage"
    private let photoNames: [String] = Array(0..<20).map{ "\($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  ShowSingleImageSegueId { // 1
            let viewController = segue.destination as! SingleImageViewController // 2
            let indexPath = sender as! IndexPath // 3
            let image = UIImage(named: photoNames[indexPath.row]) // 4
            viewController.image = image // 5
        } else {
            super.prepare(for: segue, sender: sender) // 6
        }
    }
        
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photoNames[indexPath.row]) else {
            return
        }
        cell.cellImage.image = image
        cell.dataText.text = dateFormatter.string(from: Date())
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: ShowSingleImageSegueId, sender: indexPath)
     }

    func tableView(_ tableVies: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = UIImage(named: photoNames[indexPath.row]) else {
            return 0
    }
        let photoInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let photoViewWidth = tableView.bounds.width - photoInsets.left - photoInsets.right
        let photoWidth = photo.size.width
        let scale = photoViewWidth / photoWidth
        let cellHeight = photo.size.height * scale + photoInsets.top + photoInsets.bottom
        return cellHeight
    }
}

