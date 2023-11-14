//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Uliana Lukash on 12.11.2023.
//

@testable import ImageFeed
import XCTest
import SwiftKeychainWrapper


final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //Given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertFalse(presenter.viewDidLoadCalled)
    }
    
    func testTokenValueAfterExit() {
        //Given
        let presenter = ProfileViewPresenter()
        let testTokenValue: String? = nil
        //When
        presenter.exitProfile()
        
        //Then
        XCTAssertEqual(KeychainWrapper.standard.string(forKey: "Auth token"), testTokenValue)
    }
    
    func testPresenterCallsExitProfile() {
        //Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.exitProfile()
        
        //Then
        XCTAssertTrue(presenter.profileExited)
    }
    
}
