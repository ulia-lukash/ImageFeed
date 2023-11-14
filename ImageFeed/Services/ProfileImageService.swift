//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 14.10.2023.
//

import Foundation
import SwiftKeychainWrapper

final class ProfileImageService {
    
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let decoder = JSONDecoder()
    private var lastUserName: String?
    
    // MARK: - Public Methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUserName == username {return}
        
        task?.cancel()
        lastUserName = username
        
        let request = makeRequest(username: username)
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<UserResult, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let result):
                let profileImageURL = result.profileImage.medium
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL])
            case .failure(let error):
                completion(.failure(error))
                self.lastUserName = nil
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    private func makeRequest(username: String) -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.path = "/users/\(username)"
        guard let url = urlComponents.url(relativeTo: DefaultBaseURL) else {
            assertionFailure("Failed to create URL for avatar Image")
            return URLRequest(url: URL(string: "")!)
        }
        guard let token = KeychainWrapper.standard.string(forKey: "Auth token") else {
            assertionFailure("Failed to create Token")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }    
}



