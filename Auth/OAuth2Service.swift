//
//  OAuth2Service.swift
//  FotoFlow
//
//  Created by LERÄ on 25.01.24.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
    case decodingError
    case serverError(String)
}
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

final class OAuth2Service {
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        } set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard code != lastCode, task != nil else {
            return
        }
        lastCode = code
        guard let request = authTokenRequest(code: code) else {
            assertionFailure("Invalid")
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        let session = URLSession.shared
        task = session.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
            self?.task = nil
            switch response {
            case .success(let body):
                let authToken = body.accessToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL) ?? DefaultBaseURL)
        request.httpMethod = httpMethod
        
        if let token = OAuth2TokenStorage.shared.authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

