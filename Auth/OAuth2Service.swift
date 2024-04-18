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
    
    private var task: URLSessionTask?
    private var lastCode: String?
    private var oauth2TokenStorage = OAuth2TokenStorage()
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage.token
        } set {
            OAuth2TokenStorage.token = newValue
        }
    }
    
    var isAuthenticated: Bool {
        return OAuth2TokenStorage.token != nil
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Проверка на повторные запросы с тем же кодом
        guard task == nil else {
            return
        }
        
        guard let request = authTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            defer { self?.task = nil }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.serverError("Invalid response")))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                self?.authToken = tokenResponse.accessToken
                completion(.success(tokenResponse.accessToken))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        
        task?.resume()
    }

//    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
//
//        guard !(code == lastCode && task != nil) else {
//            return
//        }
//        lastCode = code
//        guard let request = authTokenRequest(code: code) else {
//            assertionFailure("Invalid")
//            completion(.failure(NetworkError.invalidRequest))
//            return
//        }
//
//        task =  URLSession.shared.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
//            self?.task = nil
//            switch response {
//            case .success(let body):
//                let authToken = body.accessToken
//                completion(.success(authToken))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
//    private func showLoginAlert(error: Error) {
//        let alert = AlertModel(title: "Что-то пошло не так :(",
//                               text: "Не удалось войти в систему",
//                               buttonText: "OK")
//    }
    
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


