//
//  ProfileService.swift
//  FotoFlow
//
//  Created by LERÄ on 20.03.24.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private var profile: Profile?
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        guard let request = makeFetchProfileRequest(token: token) else {
            assertionFailure("Invalid request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        task = session.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>) in
            self?.task = nil
            switch response {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func makeFetchProfileRequest(token: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
    }
}


