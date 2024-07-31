

import Foundation

enum Constants {
    
    static let AccessKey = "6jDFSnen7ZD50h-6Hvjub-3AvzVJlIgObbHfJY1o6B8"
    static let SecretKey = "dQI94eM-CjsUVd2kaEZiVgB9R8eZ4q15XHMuVUNn78M"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"

    static let AccessScope = "public+read_user+write_likes"
    static let DefaultBaseURL = URL(string:"https://api.unsplash.com")
    static let PhotoListUrl = URL(string:"https://api.unsplash.com/photos")!
    static let UserPhotoListUrl = URL(string:"https://api.unsplash.com/users")!
    
    static let AuthURLString = "https://unsplash.com/oauth/authorize"

}

struct AuthConfiguration {
    let AccessKey: String
    let SecretKey: String
    let RedirectURI: String
    let AccessScope: String
    let DefaultBaseURL: URL
    let AuthURLString: String
    
    init(AccessKey: String, SecretKey: String, RedirectURI: String, AccessScope: String, DefaultBaseURL: URL, AuthURLString: String) {
        self.AccessKey = AccessKey
        self.SecretKey = SecretKey
        self.RedirectURI = RedirectURI
        self.AccessScope = AccessScope
        self.DefaultBaseURL = DefaultBaseURL
        self.AuthURLString = AuthURLString
    }
    
    static var standard: AuthConfiguration{
        return AuthConfiguration(
            AccessKey: Constants.AccessKey,
            SecretKey: Constants.SecretKey,
            RedirectURI: Constants.RedirectURI,
            AccessScope: Constants.AccessScope,
            DefaultBaseURL: Constants.DefaultBaseURL!,
            AuthURLString: Constants.AuthURLString)
    }
}
