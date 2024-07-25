//
//  ProfileModels.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 19.07.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let bio: String?
    var loginName: String {
        return "@\(username)"
    }
    
    init(username: String, firstName: String, lastName: String?, bio: String?) {
        self.username = username
        self.name = "\(firstName) \(lastName ?? "")"
        self.bio = bio
    }
}

