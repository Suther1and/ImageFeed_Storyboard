//
//  File.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 15.07.2024.
//

import Foundation

enum Constants {
    static let accessKey = "wI-KD8H1S-J08T9pX_3ODw_Za5VEwoDathBVzGNtJXs"
    static let secretKey = "dnhw_pBHdBE9w8KFnFcBDOsGO7OW1tFYd8oUnsTTCwc"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
