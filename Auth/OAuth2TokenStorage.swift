//
//  OAuth2TokenStorage.swift
//  FotoFlow
//
//  Created by LERÄ on 25.01.24.
//

import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private let tokenKey = "OAuth2BearerToken"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        } set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
