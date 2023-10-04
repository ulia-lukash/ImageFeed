//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 03.10.2023.
//

import Foundation

class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaults.Keys.bearerToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.bearerToken.rawValue)
        }
    }
}

extension UserDefaults {
    enum Keys : String{
        case bearerToken
    }
}
