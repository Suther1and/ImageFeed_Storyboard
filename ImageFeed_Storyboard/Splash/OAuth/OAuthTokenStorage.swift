//
//  OAuthTokenStorage.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 16.07.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "bearerToken")
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: "bearerToken")
            }
        }
    }
    
    static func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: "bearerToken")
    }
}
