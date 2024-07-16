//
//  OAuth2Service.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 16.07.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    let storage = OAuth2TokenStorage()

    private init() {
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseUrl = URL(string: "https://unsplash.com") else {
            fatalError("Invalid base URL")
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
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            fatalError("Invalid request")
        }
        URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.storage.token = response.accessToken
                    
                    completion(.success(response.accessToken))
                } catch {
                    print("Error decoding OAuth token response: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error fetching OAuth token: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
