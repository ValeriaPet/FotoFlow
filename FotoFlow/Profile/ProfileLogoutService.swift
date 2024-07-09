
import Foundation
import WebKit
import Kingfisher

final class ProfileLogoutService {
    
    static let profileLogoutService = ProfileLogoutService()
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanUserData()
        switchToSplashController()
    }
    
    private func cleanCookies() {
        print("Cleaning cookies...")
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                    print("Removed data for record: \(record)")
                })
            }
        }
    }
    
    private func cleanUserData() {
        
        OAuth2TokenStorage.shared.token = nil
        
        ProfileService.profileService.cleanUserProfile()
        ProfileImageService.profileImageService.cleanUserAvatarURL()
        
        ImagesListService.imagesListService.cleanPhotos()

        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
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
