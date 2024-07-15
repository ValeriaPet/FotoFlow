

import Foundation

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? {get set}
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
    
        let nameLabel = userProfile.profile.username
        let nickLabel = userProfile.profile.loginName
        let greetLabel = userProfile.profile.bio ?? ""
       
        view?.UIElements(name: nameLabel, nick: nickLabel, greet: greetLabel)
    
    }
    
    private func userImageUrlUpdate() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] notification in
                let urlString = notification.userInfo?["URL"] as? String
                guard let url = URL(string: urlString ?? "") else { return }
                self?.view?.updateAvatar(url: url)
            }
    }
}



