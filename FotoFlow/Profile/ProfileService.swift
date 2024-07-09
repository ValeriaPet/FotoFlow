//
//  ProfileService.swift
//  FotoFlow
//
//  Created by LERÄ on 20.03.24.
//

import Foundation

final class ProfileService {
    
    static let profileService = ProfileService()
    var profile: Profile?
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    
//    private init() {}
    
//    func updateProfileDetails(userToken: String, completion: @escaping (Bool) -> Void) {
//        
//        self.fetchProfile(token: userToken) {result in
//            DispatchQueue.main.async {
//            }
//            switch result {
//            case .success(let profile):
//                self.profile?.username = profile.username
//                self.profile?.name = profile.name
//                self.profile?.loginName = "@\(profile.username)"
//                self.profile?.bio = profile.bio
//                self.task = nil
//                completion(true)
//            case .failure(let error):
//                print("CONSOLE func fetchUserProfileData:", error.localizedDescription)
//                completion(false)
//            }
//        }
//    }
    
    func cleanUserProfile() {
        profile = Profile (username: "",
                          name: "",
                          loginName: "",
                          bio: nil
        )
    }
        
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void){

        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeFetchProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            print("\(String(describing: Profile.self)) [dataTask:] - Network Error")
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>) in
            self?.task = nil
            switch response {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
                print("\(String(describing: ProfileResult.self)) [dataTask:] - Network Error \(error)" )
            }
        }
        self.task = task
    }
    

    func makeFetchProfileRequest(token: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: Constants.DefaultBaseURL!)
    }
}


