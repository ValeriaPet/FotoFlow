//
//  ProfilesStructures.swift
//  FotoFlow
//
//  Created by LERÄ on 21.03.24.
//

import Foundation

struct ProfileResult: Codable {
    var userLogin: String
    var firstName: String?
    var lastName: String?
    var bio: String?
    var profileImage: ProfileImage?
    
    private enum CodingKeys: String, CodingKey {
        case userLogin = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case profileImage = "profile_image"
    }
}
    
    struct Profile {
        var username: String
        var name: String
        var loginName: String
        var bio: String?
        
    }
        struct ProfileImage: Codable {
            let small: String?
            let medium: String?
            let large: String?
        }
    
    extension Profile {
        init(result profile: ProfileResult) {
            self.init(
                username: profile.userLogin,
                name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
                loginName: "@\(profile.userLogin)",
                bio: profile.bio
                )
        }
    }
extension ProfileImage {
    init(result profile: ProfileResult) {
        self.init (
            small: profile.profileImage?.small,
            medium: profile.profileImage?.medium,
            large: profile.profileImage?.large
        )
    }
}

