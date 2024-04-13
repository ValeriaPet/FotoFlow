//
//  OAuth2TokenStorage.swift
//  FotoFlow
//
//  Created by LERÄ on 25.01.24.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    //    static let shared = OAuth2TokenStorage()
    //    private let tokenKey = "OAuth2BearerToken"
    
    private let userDefaults = UserDefaults.standard
    static let shared = OAuth2Service()
    
    
    static var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Keys.token.rawValue)
            }
        }
    }
    private enum Keys: String {
        case token
    }
}


