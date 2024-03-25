//
//  ProfileImageService.swift
//  FotoFlow
//
//  Created by LERÄ on 25.03.24.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private var profile: ProfileImage?
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<ProfileImage, Error>) -> Void) {
        guard let request = makeFetchProfileImageRequest(token: username) else {
            assertionFailure("Invalid request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task = fetch(request: request) { [weak self] response in
            self?.task = nil
            switch response {
            case .success(let profileResult):
                let profile = ProfileImage(result: profileResult)
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
        
        
    }
    
    func makeFetchProfileImageRequest(token: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/users/:username",
            httpMethod: "GET",
            baseURL: DefaultBaseURL
        )
    }
}
