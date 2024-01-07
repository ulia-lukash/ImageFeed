//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 25.10.2023.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
        case id, width, height, description, urls
    }
}
