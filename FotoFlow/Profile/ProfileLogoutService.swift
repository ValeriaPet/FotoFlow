
import Foundation
import WebKit
import Kingfisher

final class ProfileLogoutService {
    
    static let profileLogoutService = ProfileLogoutService()
    private init() { }
    
    func logout() {
        print("ProfileLogoutService: Starting logout process...")
        cleanCookies()
        cleanUserData()
        switchToSplashController()
    }
    
    private func cleanCookies() {
        print("ProfileLogoutService: Cleaning cookies...")
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                    print("ProfileLogoutService: Removed data for record: \(record)")
                })
            }
        }
    }
    
    private func cleanUserData() {
        print("ProfileLogoutService: Cleaning user data...")
        OAuth2TokenStorage.shared.token = nil
        
        ProfileService.profileService.cleanUserProfile()
        ProfileImageService.profileImageService.cleanUserAvatarURL()
        
        ImagesListService.imagesListService.cleanPhotos()

        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        print("ProfileLogoutService: User data cleaned")
    }
    
    private func switchToSplashController() {
        print("ProfileLogoutService: Switching to Splash Controller...")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("ProfileLogoutService: Invalid window configuration")
            return
        }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
        print("ProfileLogoutService: Switched to Splash Controller")
    }
}

