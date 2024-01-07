//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 25.10.2023.
//

import Foundation

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small : String
    let thumb: String
}
