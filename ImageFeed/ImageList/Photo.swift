//
//  Photo.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 25.10.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let rawImageURL: String
    let smallImageURL: String
    let thumbImageURL: String
    let fullImageURL: String
    let regularImageURL: String
    let isLiked: Bool
}
