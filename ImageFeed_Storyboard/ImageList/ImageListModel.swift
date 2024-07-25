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
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(result photo: PhotoResult) {
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)
        self.createdAt = photo.createdAt
        self.welcomeDescription = photo.description ?? ""
        self.thumbImageURL = photo.urls?.thumb ?? ""
        self.largeImageURL = photo.urls?.full ?? ""
        self.isLiked = photo.isLiked ?? false
    }
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: Date?
    let height: CGFloat
    let width: CGFloat
    let description: String?
    let isLiked: Bool?
    let urls: URLResult?
}

struct URLResult: Codable {
    let full: String
    let thumb: String
}


 
