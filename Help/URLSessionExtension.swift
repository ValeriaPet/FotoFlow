//
//  URLSessionExtension.swift
//  FotoFlow
//
//  Created by LERÄ on 02.04.24.
//

import Foundation

// ProfileResult, OAuthTokenResult

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(result))
                    } catch {
                        fulfillCompletion(.failure(AuthServiceError.urlRequestError(error)))
                        print("\(String(describing: T.self)) [dataTask:] - Network Error \(error)" )
                    }
                } else {
                    fulfillCompletion(.failure(AuthServiceError.httpStatusCode(statusCode)))
                    print("\(String(describing: T.self)) [dataTask:] - Network Error \(statusCode)" )
                }
            } else if let error = error {
                
                fulfillCompletion(.failure(AuthServiceError.urlRequestError(error)))
                print("\(String(describing: T.self)) [dataTask:] - Network Error \(error)" )
            } else {
                fulfillCompletion(.failure(AuthServiceError.urlSessionError))
                print("\(String(describing: T.self)) [dataTask:] - Network Error")
            }
        })
        task.resume()
        return task
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
        
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

