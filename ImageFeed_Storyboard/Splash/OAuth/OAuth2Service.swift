//
//  OAuth2Service.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 16.07.2024.
//

import Foundation

final class OAuth2Service {
    
    //MARK: - Private Properties
    static let shared = OAuth2Service()
    private let storage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    
    
    //MARK: - Initializer
    private init() {}
    
    
    //MARK: - Methods
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseUrl = URL(string: "https://unsplash.com") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseUrl
        ) else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(_ code: String,completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(AuthServiceErrors.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceErrors.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result:
            Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let response):
                self?.storage.token = response.accessToken
                completion(.success(response.accessToken))
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(AuthServiceErrors.invalidResponse) - Ошибка получения OAuth токена, \(error.localizedDescription)")
                completion(.failure(AuthServiceErrors.invalidResponse))
            }
            self?.task = nil
            self?.lastCode = nil
            
        }
        self.task = task
        task.resume()
    }
}

