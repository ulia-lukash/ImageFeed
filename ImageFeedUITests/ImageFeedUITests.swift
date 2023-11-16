//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Uliana Lukash on 13.11.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    // MARK: - Constants
    
    let EMAIL = "ulianalukash@yandex.ru"
    let PASSWORD = "vawmat-xibhof-cuhTi9"
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launch()
    }
    
    
    
    func testAuth() throws {
        // тестируем сценарий авторизации:
        
        // Нажать кнопку авторизации
        app.buttons["Authenticate"].tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        let webViewsQuery = app.webViews.webViews.webViews
        let webView = webViewsQuery.otherElements["Connect ImageFeed + Unsplash | Unsplash"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        // Ввести данные (логин и пароль) в форму
        let loginTextField = webView.children(matching: .textField).element // вводим Логин
        loginTextField.tap()
        loginTextField.typeText(EMAIL)
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        app.toolbars.buttons["Done"].tap()

        let passwordTextField = webView.children(matching: .secureTextField).element // вводим пароль
        passwordTextField.tap()
        passwordTextField.typeText(PASSWORD)
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        app.toolbars.buttons["Done"].tap()
        
        // Нажать кнопку логина
        webViewsQuery.buttons["Login"].tap()
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        
        // Подождать, пока открывается и загружается экран ленты
        sleep(3)
        // Сделать жест «смахивания» вверх по экрану для его скролла
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)
        // Поставить лайк в ячейке верхней картинки
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let likeButton = cellToLike.buttons["LikeButton"]
        likeButton.tap() 
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        sleep(2)
        // Отменить лайк в ячейке верхней картинки
        let dislikeButton = cellToLike.buttons["LikeButton"]
        dislikeButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        sleep(2)
        // Нажать на верхнюю ячейку
        let topCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        topCell.tap()
        let imageScrollView = app.scrollViews.images.element(boundBy: 0)
        // Подождать, пока картинка открывается на весь экран
        sleep(10)
        // Увеличить картинку
        imageScrollView.pinch(withScale: 4, velocity: 1)
        // Уменьшить картинку
        imageScrollView.pinch(withScale: 0.5, velocity: -1)
        sleep(2)
        // Вернуться на экран ленты
        app.buttons["ReturnButton"].tap()
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        sleep(2)
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        
        // Подождать, пока открывается и загружается экран ленты
        sleep(2)
        // Перейти на экран профиля
        app.tabBars.buttons.element(boundBy: 1).tap()
        // Проверить, что на нём отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts["Uliana Lukash"].exists)
        XCTAssertTrue(app.staticTexts["@uli_lukash"].exists)
        XCTAssertTrue(app.staticTexts["bum-bum-bio"].exists)
        // Нажать кнопку логаута
        sleep(2)
        app.buttons["ipad.and.arrow.forward"].tap()
        sleep(2)
        app.alerts["Выход"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        // Проверить, что открылся экран авторизации
        app.buttons["Authenticate"].tap()
    }
}
