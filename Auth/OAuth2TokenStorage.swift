//
//  OAuth2TokenStorage.swift
//  FotoFlow
//
//  Created by LERÄ on 25.01.24.
//

import Foundation

final class OAuth2TokenStorage {
    
    //    static let shared = OAuth2TokenStorage()
    //    private let tokenKey = "OAuth2BearerToken"
    
    private let userDefaults = UserDefaults.standard
    static let shared = OAuth2Service()
    
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        } set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    private enum Keys: String {
        case token
    }
}
