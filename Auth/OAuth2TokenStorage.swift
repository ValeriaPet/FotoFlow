//
//  OAuth2TokenStorage.swift
//  FotoFlow
//
//  Created by LERÄ on 25.01.24.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
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
    
    static func removeToken() -> Bool {
         
        let result = KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
        print("Token removed: \(result), new token is \(String(describing: KeychainWrapper.standard.string(forKey: Keys.token.rawValue)))")
            return result
        }

    private enum Keys: String {
        case token
    }
}



