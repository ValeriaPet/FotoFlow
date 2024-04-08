//
//  ProfileImageService.swift
//  FotoFlow
//
//  Created by LERÄ on 25.03.24.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private (set) var avatarURL: String?
    private var profile: ProfileImage?
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<ProfileImage, Error>) -> Void) {
        guard let request = makeFetchProfileImageRequest(userLogin: username) else {
            assertionFailure("Invalid request")
            completion(.failure(AuthServiceError.invalidRequest))
            
            NotificationCenter.default
                .post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL" : profileImageURL]
                    )
            return
        }
        let session = URLSession.shared
        task = session.objectTask (for: request) { [weak self] (response: Result<ProfileResult, Error>) in
            self?.task = nil
            switch response {
            case .success(let profileResult):
                let profile = ProfileImage(result: profileResult)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        func makeFetchProfileImageRequest(userLogin: String) -> URLRequest? {
            URLRequest.makeHTTPRequest(
                path: "/users/\(username)",
                httpMethod: "GET",
                baseURL: profileImageURL
            )
        }
    }
}
