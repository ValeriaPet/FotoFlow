import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    var profileImageView: UIImageView? { get set }
    var exitButton: UIButton? { get set }
    var logoutAlert: UIAlertController? { get set }
    var nameLabel: UILabel { get }
    var nickLabel: UILabel { get }
    var greetLabel: UILabel { get }
    func UIElements()
    func updateAvatar(url: URL)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var profileImageView: UIImageView?
    var exitButton: UIButton?
    var logoutAlert: UIAlertController?

    let nameLabel = UILabel()
    let nickLabel = UILabel()
    let greetLabel = UILabel()

    private var profileImageServiceObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIElements()
        presenter?.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                guard let self = self else { return }
                self.updateAvatar(notification: notification)
            })
        
        loadProfileData()
    }
    
    func loadProfileData() {
        guard let profile = ProfileService.profileService.profile else {
            print("ProfileViewController: No profile data available.")
            return
        }
        nameLabel.text = profile.name
        nickLabel.text = profile.loginName
        greetLabel.text = profile.bio
        ProfileImageService.profileImageService.fetchProfileImageURL(profile.username) { result in
            switch result {
            case .success(let urlString):
                if let url = URL(string: urlString) {
                    self.updateAvatar(url: url)
                } else {
                    print("Invalid URL string: \(urlString)")
                }
            case .failure(let error):
                print("Failed to fetch profile image URL:", error)
            }
        }
    }
    
    private func updateAvatar(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let avatarURL = userInfo["URL"] as? String,
            let url = URL(string: avatarURL)
        else { return }
        updateAvatar(url: url)
    }
    
    func updateAvatar(url: URL) {
        guard let profileImageView = self.profileImageView else { return }
        profileImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImageView.kf.setImage(with: url, options: [.processor(processor)])
    }
    
    func UIElements() {
        let photoImageView = UIImageView()
        let imageSize = CGSize(width: 70, height: 70)
        photoImageView.layer.cornerRadius = 35
        photoImageView.tintColor = .white
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = UIColor(named: "YP Black")
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        self.profileImageView = photoImageView
        
        nameLabel.text = "name"
        nameLabel.textColor = .ypWhiteIOS
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nickLabel.text = "nick"
        nickLabel.textColor = .ypGrayIOS
        nickLabel.font = .systemFont(ofSize: 13)
        nickLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickLabel)
        
        greetLabel.text = "greet"
        greetLabel.textColor = .ypWhiteIOS
        greetLabel.font = .systemFont(ofSize: 13)
        greetLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(greetLabel)
        
        let buttonImage = UIImage(named: "Exit")
        let exitButton = UIButton.systemButton(with: buttonImage!, target: self, action: #selector(self.logoutButtonAction))
        exitButton.tintColor = .ypRedIOS
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.accessibilityIdentifier = "Exit"
        self.exitButton = exitButton
        
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            photoImageView.heightAnchor.constraint(equalToConstant: imageSize.height),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            nameLabel.widthAnchor.constraint(equalToConstant: 241),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 148),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            nickLabel.widthAnchor.constraint(equalToConstant: 200),
            nickLabel.heightAnchor.constraint(equalToConstant: 18),
            nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nickLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            greetLabel.widthAnchor.constraint(equalToConstant: 300),
            greetLabel.heightAnchor.constraint(equalToConstant: 18),
            greetLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8),
            greetLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            exitButton.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
        ])
    }
    
//    @objc func logoutButtonAction() {
//
//        let alert = AlertModel(title: "Пока :(",
//                               text: "Ты точно хочешь меня покинуть?",
//                               buttonText: "Да!",
//                               completion: {_ in
//            ProfileLogoutService.profileLogoutService.logout()
//        })
//        AlertPresenter.showAlert(alert: alert, on: self)
//    }
    
    @objc func logoutButtonAction() {
        print("ProfileViewController: logoutButtonAction called")
        let alert = UIAlertController(title: "Пока :(",
                                      message: "Ты точно хочешь меня покинуть?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да!", style: .destructive, handler: { [weak self] _ in
            self?.presenter?.profileLogout()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        self.logoutAlert = alert
    }
}
