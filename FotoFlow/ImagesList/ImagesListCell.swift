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
    
    @IBOutlet var cellImage: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet var dataText: UILabel!
    
    @IBOutlet var gradientView: UIView!
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        self.cellImage.kf.cancelDownloadTask()
    }
}
