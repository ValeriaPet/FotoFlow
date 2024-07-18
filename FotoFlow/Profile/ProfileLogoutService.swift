import Foundation
import WebKit
import Kingfisher

final class ProfileLogoutService {
    
    static let profileLogoutService = ProfileLogoutService()
    private init() { }
    
    func logout() {
        print("ProfileLogoutService: Starting logout process...")
        cleanCookies {
            self.cleanUserData {
                DispatchQueue.main.async {
                    self.switchToSplashController()
                }
            }
        }
    }
    
    private func cleanCookies(completion: @escaping () -> Void) {
        print("ProfileLogoutService: Cleaning cookies...")
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            let dispatchGroup = DispatchGroup()
            for record in records {
                dispatchGroup.enter()
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                    print("ProfileLogoutService: Removed data for record: \(record)")
                    dispatchGroup.leave()
                })
            }
            dispatchGroup.notify(queue: .main) {
                completion()
            }
        }
    }
    
    private func cleanUserData(completion: @escaping () -> Void) {
        print("ProfileLogoutService: Cleaning user data...")
        OAuth2TokenStorage.shared.token = nil
        ProfileService.profileService.cleanUserProfile()
        ProfileImageService.profileImageService.cleanUserAvatarURL()
        ImagesListService.imagesListService.cleanPhotos()
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        print("ProfileLogoutService: User data cleaned")
        completion()
    }
    
    private func switchToSplashController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
