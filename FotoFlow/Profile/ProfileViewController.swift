//
//  ProfileViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 23.12.23.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
//    let photoImageView = UIImageView()
    let name = UILabel()
    let nick = UILabel()
    let greet = UILabel()
    
        private let photoImageView = {
            let photoImage = UIImage(systemName: "person.crop.circle.fill")
            let photoImageView = UIImageView(image: photoImage)
            photoImageView.layer.cornerRadius = 35
            photoImageView.tintColor = .white
            photoImageView.clipsToBounds = true
            photoImageView.backgroundColor = UIColor(named: "YP Black")
    
            return photoImageView
        } ()
    
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
        if let url = ProfileImageService.shared.avatarURL {
            updateAvatar(url: url)
        }
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                guard let self = self else {return}
                self.updateAvatar(notification: notification)
            })
        
        loadProfileData()
    }
    
    func loadProfileData() {
        let userToken = "access_token"
        ProfileService.shared.fetchProfile(userToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.name.text = profile.name
                    self?.nick.text = profile.loginName
                    self?.greet.text = profile.bio
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateAvatar(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let avatarURL = userInfo["URL"] as? String,
            let url = URL(string: avatarURL)
        else {return}
        updateAvatar(url: url)
    }
    private func updateAvatar(url: URL) {
        photoImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        photoImageView.kf.setImage(with: url,
                                   placeholder: UIImage(named: "PlaceholderAvatar"), options: [.processor(processor)])
    }
    
    func layout() {
        
        let imageSize = CGSize(width: 70, height: 70)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            photoImageView.heightAnchor.constraint(equalToConstant: imageSize.height),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        name.textColor = .ypWhiteIOS
        name.font = .boldSystemFont(ofSize: 23)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(name)
        
        NSLayoutConstraint.activate([
            name.widthAnchor.constraint(equalToConstant: 241),
            name.heightAnchor.constraint(equalToConstant: 18),
            name.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 148),
            name.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        nick.textColor = .ypGrayIOS
        nick.font = .systemFont(ofSize: 13)
        
        nick.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nick)
        
        NSLayoutConstraint.activate([
            nick.widthAnchor.constraint(equalToConstant: 200),
            nick.heightAnchor.constraint(equalToConstant: 18),
            nick.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            nick.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        greet.textColor = .ypWhiteIOS
        greet.font = .systemFont(ofSize: 13)
        
        greet.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(greet)
        
        NSLayoutConstraint.activate([
            greet.widthAnchor.constraint(equalToConstant: 300),
            greet.heightAnchor.constraint(equalToConstant: 18),
            greet.topAnchor.constraint(equalTo: nick.bottomAnchor, constant: 8),
            greet.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        let exitButton = UIButton(type: .custom)
        let buttonImage = UIImage(named: "Exit")
        
        exitButton.tintColor = .ypRedIOS
        exitButton.setImage(buttonImage, for: .normal)
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            exitButton.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
        ])
    }
}
