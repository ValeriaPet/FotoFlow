//
//  SingleImageViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 24.12.23.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    var imageURL: URL?
    private var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = 0.05
        scrollView.maximumZoomScale = 1.25
        setImageKF()
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didShareButton(_ sender: Any) {
        if let image {
            let share = UIActivityViewController(
                activityItems: [image],
                applicationActivities: nil)
            
            present(share, animated: true, completion: nil)
        }
    }
    
    private func setImageKF() {
        guard let imageURL else {
            return
        }
        
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) {[weak self] (result: Result<RetrieveImageResult, KingfisherError>) in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success:
                    guard let image = self?.imageView.image else {return}
                    self?.image = image
                    self?.imageView.frame.size = image.size
                    self?.rescaleAndCentre(image: image)
                case .failure(let error):
                    print("setImageWithKF: Ошибка загрузки фото", error.localizedDescription)
                    
                    if let self = self {
                        let alert = AlertModel(title: "Что-то пошло не так(",
                                               text: "Попробовать еще раз?",
                                               buttonText: "Повторить",
                                               completion: {_ in self.setImageKF()
                        })
                        
                        AlertPresenter.showAlert(alert: alert, on: self)
                    }
                }
            }
        }
    }
    
    private func rescaleAndCentre(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        if x > 0, y > 0 {
            scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: 0, right: 0)
        } else if x > 0 {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: x, bottom: 0, right: 0)
        } else if y > 0 {
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        }
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard image != nil else {
            return
        }
    }
}

