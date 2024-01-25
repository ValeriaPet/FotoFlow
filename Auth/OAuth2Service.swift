//
//  OAuth2Service.swift
//  FotoFlow
//
//  Created by LERÄ on 25.01.24.
//

import Foundation

final class OAuth2Service {
    
    let tokenStorage = OAuth2TokenStorage()
    
    func fetchAuthToken(code: String, completion: @escaping(Result<OAuthTokenResponseBody, Error>) -> Void) {
        
        let AccessKey = "6jDFSnen7ZD50h-6Hvjub-3AvzVJlIgObbHfJY1o6B8"
        let RedirectURL = "urn:ietf:wg:oauth:2.0:oob"
        let ResponseType = "code"
        let AccessScope = "public+read_user+write_likes"
        
        let params = [
            "access_key": AccessKey,
            "redirect_url": RedirectURL,
            "response_type": ResponseType,
            "scope": AccessScope,
            "code": code
        ]
        
        let url = URL(string: "https://unsplash.com/oauth/token")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            completion(.failure(error as NSError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let body = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                
                self.tokenStorage.token = body.accessToken
                
                completion(.success(body))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
     struct OAuthTokenResponseBody: Codable {
        
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAT: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAT = "created_at"
        }
    }
}
