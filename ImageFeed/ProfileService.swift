//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 14.10.2023.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let decoder = JSONDecoder()
    private var lastCode: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == token {return}
        task?.cancel()
        lastCode = token
                
        let request = makeRequest(token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>)  in
                    guard let self = self else { return }
                    switch result {
                    case .success(let profileResult):
                        self.profile = Profile(result: profileResult)
                        guard let profile = self.profile else {return}
                        completion(.success(profile))
                        self.profile = profile
                        self.task = nil
                    case .failure(let error):
                        completion(.failure(error))
                        self.lastCode = nil
                    }
                }
                self.task = task
                task.resume()
    }
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

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

extension ProfileService {
    
    private func makeRequest(token: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.path = "/me"
        guard let url = urlComponents.url(relativeTo: DefaultBaseURL) else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
