import Foundation

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func profileLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let userProfile = ProfileService.profileService
    private let userProfileImageService = ProfileImageService.profileImageService
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        profileUpdate()
        view?.UIElements()
        if let url = userProfileImageService.avatarURL {
            view?.updateAvatar(url: url)
        } else {
            userImageUrlUpdate()
        }
    }
    
    func profileLogout() {
        print("ProfilePresenter: profileLogout called")
        ProfileLogoutService.profileLogoutService.logout()
    }
    
    private func profileUpdate() {
        guard let profile = userProfile.profile else { return }
        view?.nameLabel.text = profile.name
        view?.nickLabel.text = profile.loginName
        view?.greetLabel.text = profile.bio
    }
    
    private func userImageUrlUpdate() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] notification in
                guard let urlString = notification.userInfo?["URL"] as? String,
                      let url = URL(string: urlString) else { return }
                self?.view?.updateAvatar(url: url)
            }
    }
}

