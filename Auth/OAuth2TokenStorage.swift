//
//  OAuth2TokenStorage.swift
//  FotoFlow
//
//  Created by LERÄ on 25.01.24.
//

import Foundation

class OAuth2TokenStorage {
    
    private let tokenKey = "oauth2_token"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        } set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
