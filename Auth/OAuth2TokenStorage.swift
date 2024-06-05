

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Keys.token.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
    
    private enum Keys: String {
        case token
    }
}



