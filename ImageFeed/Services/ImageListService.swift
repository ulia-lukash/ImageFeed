//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 25.10.2023.
//

import Foundation
import SwiftKeychainWrapper

class ImageListService {
    
    // MARK: - Public Properties
    static let shared = ImageListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()
    
    // MARK: - Public Methods
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        if task != nil { return }
        
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        lastLoadedPage = nextPage
        
        guard let request = makeRequest(path: "/photos?page=\(nextPage)") else {
            return assertionFailure("Нет связи с библиотекой картинок")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResult):
                self.preparePhoto(photoResult)
                NotificationCenter.default.post(name: ImageListService.DidChangeNotification, object: self, userInfo: ["photos" : self.photos] )
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func preparePhoto(_ photoResult: [PhotoResult]) {
        let newPhotos = photoResult.map { item in
            return Photo(
                id: item.id,
                size: CGSize(width: item.width, height: item.height),
                createdAt: dateFormatter.date(from: item.createdAt!),
                welcomeDescription: item.description,
                rawImageURL: item.urls.raw,
                smallImageURL: item.urls.small,
                thumbImageURL: item.urls.thumb,
                fullImageURL: item.urls.full,
                regularImageURL: item.urls.regular,
                isLiked: item.likedByUser)
        }
        self.photos.append(contentsOf: newPhotos)
    }
}

extension ImageListService {
    
    private func makeRequest(path: String) -> URLRequest? {
        guard let baseURL = URL(string: path, relativeTo: DefaultBaseURL) else {
            assertionFailure("url is nil")
            return nil
        }
        
        var request = URLRequest(url: baseURL)
        guard let token = KeychainWrapper.standard.string(forKey: "Auth token") else {
            assertionFailure("token is nil)")
            return nil
        }
        print("Ваш токен! ---->  " + token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension ImageListService {
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = KeychainWrapper.standard.string(forKey: "Auth token") else {
            return assertionFailure("Error like request")}
        let method = isLike ?  "POST" : "DELETE"
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: method,
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        rawImageURL: photo.rawImageURL,
                        smallImageURL: photo.smallImageURL,
                        thumbImageURL: photo.thumbImageURL,
                        fullImageURL: photo.fullImageURL,
                        regularImageURL: photo.regularImageURL,
                        isLiked: !photo.isLiked)
                    self.photos[index] = newPhoto
                }
                completion (.success(()))
            case .failure(let error):
                completion (.failure(error))
            }
        }
        task.resume()
    }
}


struct LikeResult: Decodable {
    let photo: PhotoResult
}
