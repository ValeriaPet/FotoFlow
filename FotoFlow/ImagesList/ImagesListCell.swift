//
//  ImagesListCell.swift
//  FotoFlow
//
//  Created by LERÄ on 19.12.23.
//


import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet var dataText: UILabel!
    @IBOutlet var gradientView: UIView!
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func configure(with imageUrl: URL, date: String, isLiked: Bool, completion: @escaping () -> Void) {
        setFavoriteButtonImage(isLiked: isLiked)
    }
        
    func setFavoriteButtonImage(isLiked: Bool) {
        guard let image = UIImage(named: isLiked ? "favorites_active" : "favorites_no_active") else {
            return
        }
        likeButton.setImage(image, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        self.cellImage.kf.cancelDownloadTask()
    }
}
