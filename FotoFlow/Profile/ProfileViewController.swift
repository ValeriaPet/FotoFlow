//
//  ProfileViewController.swift
//  FotoFlow
//
//  Created by LERÄ on 23.12.23.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let photo = UIImageView()
        let image = UIImage(named: "photo.user")
        let imageSize = CGSize(width: 70, height: 70)
        
        photo.image = image
        
        
        photo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photo)
        
        NSLayoutConstraint.activate([
            photo.widthAnchor.constraint(equalToConstant: imageSize.width),
            photo.heightAnchor.constraint(equalToConstant: imageSize.height),
            photo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            photo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        let name = UILabel()
        name.text = "Екатерина Новикова"
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
        
        let nick = UILabel()
        nick.text = "@ekaterina_nov"
        nick.textColor = .ypGrayIOS
        nick.font = .systemFont(ofSize: 13)
        
        nick.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nick)
        
        NSLayoutConstraint.activate([
            nick.widthAnchor.constraint(equalToConstant: 99),
            nick.heightAnchor.constraint(equalToConstant: 18),
            nick.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            nick.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        let greet = UILabel()
        greet.text = "Hello!"
        greet.textColor = .ypWhiteIOS
        greet.font = .systemFont(ofSize: 13)
        
        greet.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(greet)
        
        NSLayoutConstraint.activate([
            greet.widthAnchor.constraint(equalToConstant: 77),
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
            exitButton.centerYAnchor.constraint(equalTo: photo.centerYAnchor)
            ])
    
    }
}
    
