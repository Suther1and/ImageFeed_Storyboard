//
//  ProfileService.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 19.07.2024.
//

import Foundation

final class ProfileService {
    
    //MARK: - Private Properties
    private var task: URLSessionTask?
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    
    
    //MARK: - Initializer
    private init() {}
    
    //MARK: - Methods
    func makeProfileInfoURLRequest() throws -> URLRequest? {
        guard let baseURL = Constants.defaultBaseURL else {
            throw ProfileServiceErrors.invalidBaseURL
        }
        guard let url = URL(string: "/me", relativeTo: baseURL) else {
            throw ProfileServiceErrors.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = OAuth2TokenStorage().token else {
            throw ProfileServiceErrors.tokenError
        }
        let tokenStringField = "Bearer \(token)"
        
        request.setValue(tokenStringField, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = try? makeProfileInfoURLRequest() else {
            completion(.failure(ProfileServiceErrors.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let response):
                let profile = Profile(username: response.username, firstName: response.firstName, lastName: response.lastName, bio: response.bio)
                self.profile = profile
                ProfileImageService.shared.fetchProfileImageURL(username: response.username) { _ in }
                completion(.success(profile))
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(ProfileServiceErrors.fetchProfileError) - Ошибка получения данных профиля, \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
