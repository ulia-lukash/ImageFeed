//
//  UserResult.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 25.10.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ImageResult
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
