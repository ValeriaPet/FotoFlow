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
    
    private (set) var avatarURL: URL?
    private var profile: ProfileImage?
    
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(_ username: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let request = makeFetchProfileImageRequest(username: username) else
        {return}
        
        let session = URLSession.shared
        let task = session.objectTask (for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            
            guard let self = self else {return}
            
            switch result {
            case .success(let profilePhoto):
                guard let largePhoto = profilePhoto.profileImage?.large else {return}
                
                self.avatarURL = URL(string: largePhoto)
                completion(.success(largePhoto))
                NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": largePhoto]
                    )
            case .failure(let error):
                completion(.failure(error))
                print("\(String(describing: ProfileResult.self)) [dataTask:] - Network Error \(error)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
        
        func makeFetchProfileImageRequest(username: String) -> URLRequest? {
            URLRequest.makeHTTPRequest(
                path: "/users/\(username)",
                httpMethod: "GET",
                baseURL: DefaultBaseURL
            )
        }
    }
}
