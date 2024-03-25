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
        
        task = fetch(request: request) { [weak self] response in
            self?.task = nil
            switch response {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        func fetch(request: URLRequest, completion: @escaping(Result<ProfileResult, Error>)->Void) -> URLSessionTask {
            let task = urlSession.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil,
                          let response = response as? HTTPURLResponse,
                          200 ..< 300 ~= response.statusCode else {
                        completion(.failure(NetworkError.urlSessionError))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(ProfileResult.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(NetworkError.urlRequestError(error)))
                    }
                }
            }
            task.resume()
            return task
        }
        
        func makeFetchProfileRequest(token: String) -> URLRequest? {
            URLRequest.makeHTTPRequest(
                path: "/me",
                httpMethod: "GET",
                baseURL: DefaultBaseURL
            )
        }
    }
}

