//
//  ImageListModel.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 25.07.2024.
//

import Foundation


struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let fullImageURL: String
    let isLiked: Bool
    
    init(result photo: PhotoResult) {
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)
        self.createdAt = photo.createdAt
        self.welcomeDescription = photo.description ?? ""
        self.thumbImageURL = photo.urls?.thumb ?? ""
        self.largeImageURL = photo.urls?.full ?? ""
        self.fullImageURL = photo.urls?.full ?? ""
        self.isLiked = photo.isLiked ?? false
    }
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let height: Int
    let width: Int
    let description: String?
    let isLiked: Bool?
    let urls: URLResult?
}

struct URLResult: Codable {
    let full: String
    let thumb: String
}


 
