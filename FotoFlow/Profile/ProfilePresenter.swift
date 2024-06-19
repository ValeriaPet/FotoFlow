

import Foundation

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? {get set}
    func viewDidLoad()
    func profileLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let userProfile = ProfileService.profileService
    private let userProfileImageServise = ProfileImageService.profileImageService
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        profileLogout()
        if let url = userProfileImageServise.avatarURL {
            view?.updateAvatar(url: url)
        }
        else {
            userImageUrlUpdate()
        }
    }
    func profileLogout() {
        ProfileLogoutService.profileLogoutService.logout()
    }
    
    
    private func profileUpdate() {
        
        _ = userProfile.profile?.name
        _ = userProfile.profile?.loginName
        _ = userProfile.profile?.bio
        
        
    }
    
    private func userImageUrlUpdate() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] notification in
                let urlString = String(describing: notification.userInfo?["URL"] ?? "")
                guard let url = URL(string: urlString) else {
                    return
                }
                self?.view?.updateAvatar(url: url)
            }
    }
}


