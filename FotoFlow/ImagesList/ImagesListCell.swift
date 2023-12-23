//
//  ImagesListCell.swift
//  FotoFlow
//
//  Created by LERÄ on 19.12.23.
//


import UIKit
final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    
    @IBOutlet var likeButton: UIButton!
    
    @IBOutlet var dataText: UILabel!
    
    
}
