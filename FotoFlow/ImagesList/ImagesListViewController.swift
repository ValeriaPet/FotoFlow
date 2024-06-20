
import UIKit

protocol ImageListViewControllerProtocol: AnyObject {
    func activityIndicator(show: Bool)
    func updateTableViewAnimated(with rangeOfCells: Range <Int>)
}

final class ImagesListViewController: UIViewController & ImageListViewControllerProtocol {
    
    
    @IBOutlet private var tableView: UITableView!
    
    var presenter: ImageListPresenterProtocol?
    
    private let ShowSingleImageSegueId = "ShowSingleImage"
    private var photoNames: [Photo] = []
    private let imagesListService = ImagesListService.imagesListService
    private var ImagesListServiceObserver: NSObjectProtocol?
    private let dateToStringFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter = ImageListPresenter()
        presenter?.view = self
        presenter?.viewDidLoad()
        
        imagesListService.fetchPhotosNextPage("") { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  ShowSingleImageSegueId {
            if let viewController = segue.destination as? SingleImageViewController,
               let indexPath = sender as? IndexPath {
                viewController.imageURL = photoNames[indexPath.row].largeImageURL
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }
    
    func updateTableViewAnimated(with rangeOfCells: Range <Int>) {
        tableView.performBatchUpdates {
            let indexPaths = rangeOfCells.map{ i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    private func setImageWithKF(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.cellImage.kf.indicatorType = .activity
        
        cell.cellImage.kf.setImage(
            with: photoNames[indexPath.row].thumbImageURL,
            placeholder: UIImage(named: "picture_load_placeholder")
        ) {[weak self] _ in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        setImageWithKF(for: cell, with: indexPath)
        cell.dataText.text = self.dateToStringFormatter.string(from: self.photoNames[indexPath.row].createdAt ?? Date())
        
        let likedImage = UIImage(named: self.photoNames[indexPath.row].isLiked ? "LikeIsActive" : "LikeNoActive")
        cell.likeButton.setImage(likedImage, for: .normal)
        
        cell.gradientView.layer.masksToBounds = true
        cell.gradientView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        cell.gradientView.layer.cornerRadius = 16
        let gradient = CAGradientLayer()
        gradient.frame = cell.gradientView.bounds
        gradient.colors = [UIColor.igGradientAlpha0.cgColor, UIColor.igGradientAlpha20.cgColor]
        cell.gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func activityIndicator(show: Bool){
        show ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
    }
}


extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getPhotosCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = presenter?.prepareNewCell(for: tableView, with: indexPath, on: self) else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == photoNames.count - 1 && imagesListService.task == nil {
            imagesListService.fetchPhotosNextPage("") { }
        }
    }
}


extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueId, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.getCellHeight(indexPath: indexPath, tableBoundWidth: tableView.bounds.width) ?? 0
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
      
            presenter?.changeLike(for: indexPath) {[weak cell] isLiked in
                cell?.setFavoriteButtonImage(isLiked: isLiked)
            }
        }
    }


