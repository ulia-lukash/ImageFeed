//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 12.11.2023.
//

import Foundation
import WebKit

// MARK: - Types

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Public Properties
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    // MARK: - Initializers
    
    init(authHelper: AuthHelperProtocol) {
           self.authHelper = authHelper
       }
    
    // MARK: - WebViewPresenterProtocol
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)

    }
    
    // MARK: - Public Methods
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
}
