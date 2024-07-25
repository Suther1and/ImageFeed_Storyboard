//
//  ImageListService.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 25.07.2024.
//

import Foundation

final class ImageListService {
    
    static let shared = ImageListService()
    private init() {}
    
    //MARK: - Private Properties
    private (set) var photos: [Photo] = []
    
    private var task: URLSessionTask?
    private let session = URLSession.shared
    private var pageNumber: Int = 1
    private var lastLoadedPage: Int?
    private let perPage: Int = 10
    private let tokenStorage = OAuth2TokenStorage()
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    
    //MARK: - Private Methods
    
    func makePhotosNextPageRequest(page: Int, perPage: Int) throws -> URLRequest? {
        guard let baseURL = Constants.defaultBaseURL else {
            throw ImageListErrors.invalidBaseURL
        }
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw ImageListErrors.invalidURL
        }
        components.path = "/photos"
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "client_id", value: Constants.accessKey)
        ]
        
        guard let url = components.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(tokenStorage)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = try? makePhotosNextPageRequest(page: nextPage, perPage: perPage) else {
            return
        }
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResult):
                let newPhoto = photoResult.map { Photo(result: $0) }
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhoto)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)
                }
            case .failure(let error):
                print("[ImagesListService]: AuthServiceError - \(error)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
