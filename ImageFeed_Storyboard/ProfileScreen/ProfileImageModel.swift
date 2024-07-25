//
//  ProfileImageModel.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 19.07.2024.
//

import Foundation

struct ProfileImage: Codable {
    let small: String
    let large: String
}

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
