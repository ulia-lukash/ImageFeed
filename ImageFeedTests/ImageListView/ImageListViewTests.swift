//
//  ImageListViewTests.swift
//  ImageFeedTests
//
//  Created by Uliana Lukash on 14.11.2023.
//

@testable import ImageFeed
import XCTest
import SwiftKeychainWrapper

// - Токен, если что, вывожу в консоль при получении
let authToken = "7RqxlNYpub0hpQ0d9ptA3oiv7uaUrB6kShXs54zADE0"

final class ImageListViewTests: XCTestCase {
    
    func testListPhotosCount() {
        //Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let imageListService = ImageListService()
        
//        TODO: - !!! придумать и реальзовать другие тесты
//        А можно ли это вообще реальзовать через моковые классы? Мы полуаем код из УРЛы WebView, по которому потом получаем токен, по которому уже дальше совершаем все остальные операции, а получение кода из мока как-то...
        
        KeychainWrapper.standard.set(authToken, forKey: "Auth token")
        //When
        
        let presenter = self.expectation(description: "Получаем ответ")
        
        NotificationCenter.default.addObserver(
            forName: ImageListService.DidChangeNotification,
            object: nil,
            queue: .main) { _ in
                presenter.fulfill()
            }
        _ = viewController.view
        imageListService.fetchPhotosNextPage()
        wait(for: [presenter], timeout: 5)
        
        //Then
        XCTAssertEqual(imageListService.photos.count, 10)
    }
    
}


