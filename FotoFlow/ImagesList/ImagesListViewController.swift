//
//  ViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 05.12.23.
//

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
