//
//  OAuth2Service.swift
//  FotoFlow
//
//  Created by LERÄ on 25.01.24.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case decodingError
    case serverError(String)
}
enum AuthServiceError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

final class OAuth2Service {
    
    static let oauth2Service = OAuth2Service()
    private init() {}
    
    private var task: URLSessionTask?
    private var lastCode: String?
    private var oauth2TokenStorage = OAuth2TokenStorage.shared.token

    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage.shared.token
        } set {
            OAuth2TokenStorage.shared.token = newValue
        }
    }
    
    var isAuthenticated: Bool {
        return OAuth2TokenStorage.shared.token != nil
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard task == nil else {
            return
        }
        
        guard let request = authTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) {(result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                
                OAuth2Service.oauth2Service.task = nil
                OAuth2Service.oauth2Service.lastCode = nil
                switch result {
                case .success(let token):
                    OAuth2TokenStorage.shared.token = token.accessToken
                    print("Token successfully retrieved and stored: \(token.accessToken)")
                    completion(.success(token.accessToken))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.task = task
    }
        
    private func authTokenRequest(code: String) -> URLRequest? {
        // Определяем параметры для запроса
        let params = "?client_id=\(AccessKey)" +
        "&client_secret=\(SecretKey)" +
        "&redirect_uri=\(RedirectURI)" +
        "&code=\(code)" +
        "&grant_type=authorization_code"
        
        // Формируем полный URL с параметрами
        guard let url = URL(string: "https://unsplash.com/oauth/token" + params) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        // Создаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
        let url = URL(string: "https://api.unsplash.com/oauth/token")!
    }
}


