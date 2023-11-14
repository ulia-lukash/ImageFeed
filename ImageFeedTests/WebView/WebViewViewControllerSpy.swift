//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Uliana Lukash on 12.11.2023.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    var loadRequestCalled: Bool = false
    var presenter: ImageFeed.WebViewPresenterProtocol?

    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
}

