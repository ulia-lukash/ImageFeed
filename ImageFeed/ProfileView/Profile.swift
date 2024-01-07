//
//  Profile.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 25.10.2023.
//

import Foundation

struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String?
    
    init(result: ProfileResult) {
            self.username = result.username
            self.name = ("\(result.firstName) \(result.lastName ?? "")")
            self.loginName = "@\(result.username)"
            self.bio = ("\(result.bio ?? "")")
        }
}
