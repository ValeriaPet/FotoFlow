
import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? {get set}
    var profileImageView: UIImageView? {get set}
    var exitButton: UIButton? {get set}
    var logoutAlert: UIAlertController? {get set}
    func UIElements(name: String, nick: String, greet: String)
    
    func updateAvatar(url: URL)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var profileImageView: UIImageView?
    var exitButton: UIButton?
    var logoutAlert: UIAlertController?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        
        if let url = ProfileImageService.profileImageService.avatarURL {
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
    }
    
    
    private func updateAvatar(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let avatarURL = userInfo["URL"] as? String,
            let url = URL(string: avatarURL)
        else {return}
        updateAvatar(url: url)
        
    }
    func updateAvatar(url: URL) {
        guard let photoImageView = self.profileImageView else {
            return
        }
        photoImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        photoImageView.kf.setImage(with: url,
                                   options: [.processor(processor)])
    }
    
    @objc func logoutButtonAction() {
        let alert = AlertModel(title: "Пока :(",
                               text: "Ты точно хочешь меня покинуть?",
                               buttonText: "Да!",
                               completion: {[weak self] _ in
            self?.presenter?.profileLogout()
        })
        self.logoutAlert = AlertPresenter.showAlert(alert: alert, on: self)
    }
    
//    func UIElements(name: String, nick: String, greet: String) {
//        
//        let photoImageView = UIImageView()
//        let imageSize = CGSize(width: 70, height: 70)
//        photoImageView.layer.cornerRadius = 35
//        photoImageView.tintColor = .white
//        photoImageView.clipsToBounds = true
//        photoImageView.backgroundColor = UIColor(named: "YP Black")
//        photoImageView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(photoImageView)
//        
//        let name = UILabel()
//        name.textColor = .ypWhiteIOS
//        name.font = .boldSystemFont(ofSize: 23)
//        name.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(name)
//        
//        let nick = UILabel()
//        nick.textColor = .ypGrayIOS
//        nick.font = .systemFont(ofSize: 13)
//        nick.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(nick)
//        
//        let greet = UILabel()
//        greet.textColor = .ypWhiteIOS
//        greet.font = .systemFont(ofSize: 13)
//        greet.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(greet)
//        
//        let buttonImage = UIImage(named: "Exit")
//        let exitButton = UIButton.systemButton(with: buttonImage!, target: self, action: #selector(self.logoutButtonAction))
//        exitButton.tintColor = .ypRedIOS
//        exitButton.setImage(buttonImage, for: .normal)
//        exitButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(exitButton)
//        
//        NSLayoutConstraint.activate([
//            photoImageView.widthAnchor.constraint(equalToConstant: imageSize.width),
//            photoImageView.heightAnchor.constraint(equalToConstant: imageSize.height),
//            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
//            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
//        ])
//        NSLayoutConstraint.activate([
//            name.widthAnchor.constraint(equalToConstant: 241),
//            name.heightAnchor.constraint(equalToConstant: 18),
//            name.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 148),
//            name.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
//        ])
//        NSLayoutConstraint.activate([
//            nick.widthAnchor.constraint(equalToConstant: 200),
//            nick.heightAnchor.constraint(equalToConstant: 18),
//            nick.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
//            nick.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
//        ])
//        NSLayoutConstraint.activate([
//            greet.widthAnchor.constraint(equalToConstant: 300),
//            greet.heightAnchor.constraint(equalToConstant: 18),
//            greet.topAnchor.constraint(equalTo: nick.bottomAnchor, constant: 8),
//            greet.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
//        ])
//        NSLayoutConstraint.activate([
//            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
//            exitButton.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
//        ])
//    }
    
    func UIElements(name: String, nick: String, greet: String) {
        let photoImageView = UIImageView()
        let imageSize = CGSize(width: 70, height: 70)
        photoImageView.layer.cornerRadius = 35
        photoImageView.tintColor = .white
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = UIColor(named: "YP Black")
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        
        let nameLabel = UILabel() // Исправлено имя переменной
        nameLabel.textColor = .ypWhiteIOS
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        let nickLabel = UILabel() // Исправлено имя переменной
        nickLabel.textColor = .ypGrayIOS
        nickLabel.font = .systemFont(ofSize: 13)
        nickLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickLabel)
        
        let greetLabel = UILabel() // Исправлено имя переменной
        greetLabel.textColor = .ypWhiteIOS
        greetLabel.font = .systemFont(ofSize: 13)
        greetLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(greetLabel)
        
        let buttonImage = UIImage(named: "Exit")
        let exitButton = UIButton.systemButton(with: buttonImage!, target: self, action: #selector(self.logoutButtonAction))
        exitButton.tintColor = .ypRedIOS
        exitButton.setImage(buttonImage, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        // Присваиваем exitButton свойству контроллера
        self.exitButton = exitButton
        
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            photoImageView.heightAnchor.constraint(equalToConstant: imageSize.height),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: 241),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 148),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            nickLabel.widthAnchor.constraint(equalToConstant: 200),
            nickLabel.heightAnchor.constraint(equalToConstant: 18),
            nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nickLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            greetLabel.widthAnchor.constraint(equalToConstant: 300),
            greetLabel.heightAnchor.constraint(equalToConstant: 18),
            greetLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8),
            greetLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            exitButton.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
        ])
    }

}




