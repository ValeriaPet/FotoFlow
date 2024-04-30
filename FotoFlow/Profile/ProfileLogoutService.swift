//
//  ProfileLogoutService.swift
//  FotoFlow
//
//  Created by LERÄ on 30.04.24.
//

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
  
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }
    
    private func cleanUserData() {
        
        OAuth2TokenStorage.token = nil
        
        ProfileService.shared.cleanUserProfile()
        ProfileImageService.shared.cleanUserAvatarURL()
        
        ImagesListService.shared.cleanPhotos()
        let imageListViewController = ImagesListViewController()
        imageListViewController.cleanPhotos()
        
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
