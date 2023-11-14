//
//  ImageListViewTests.swift
//  ImageFeedTests
//
//  Created by Uliana Lukash on 14.11.2023.
//

@testable import ImageFeed
import XCTest
import SwiftKeychainWrapper


final class ImageListViewTests: XCTestCase {
    
    func testListPhotosCount() {
        //Given
        let imageListService = ImageListService()
        let presenter = self.expectation(description: "Получаем ответ")
        //When
        NotificationCenter.default.addObserver(
            forName: ImageListService.DidChangeNotification,
            object: nil,
            queue: .main) { _ in
                presenter.fulfill()
            }
        imageListService.fetchPhotosNextPage()
        wait(for: [presenter], timeout: 5)
        
        //Then
        XCTAssertEqual(imageListService.photos.count, 10)
    }
    
}
