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

final class OAuth2Service {
    
    
    private let urlSession = URLSession.shared
    
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
        assert(Thread.isMainThread)
        
        if let lastCode = lastCode, task != nil {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
            task?.cancel()
        }
        
        lastCode = code
        guard let request = authTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.task = nil
                self.lastCode = nil
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(AuthServiceError.serverError("No data received")))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.authToken = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                } catch {
                    completion(.failure(AuthServiceError.decodingError))
                }
            }
        }
        
        task?.resume()
    }
    
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let responce = result.flatMap {data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(responce)
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

//fileprivate let defaultBaseURL = URL(string: "https://api.unsplash.com")!

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

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping(Result<Data, Error>)->Void)->URLSessionTask {
            let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            let task = dataTask(with: request, completionHandler: { data, response, error in
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode
                {
                    if 200 ..< 300 ~= statusCode {
                        fulfillCompletion(.success(data))
                    } else {
                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else if let error = error {
                    fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                } else {
                    fulfillCompletion(.failure(NetworkError.urlSessionError))
                }
            })
            task.resume()
            return task
        }
}
