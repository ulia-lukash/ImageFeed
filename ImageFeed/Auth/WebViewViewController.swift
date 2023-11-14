//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 03.10.2023.
//

import Foundation
import UIKit
import WebKit
import SwiftKeychainWrapper

// MARK: - Types

protocol WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    // MARK: - Public Properties

    var presenter: WebViewPresenterProtocol?
    let authService = OAuth2Service()
    let profileService = ProfileService.shared
    static let shared = WebViewViewController()
    var delegate: WebViewViewControllerDelegate?

    // MARK: - IBOutlet
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: - Private Properties

    private var estimatedProgressObservation: NSKeyValueObservation?
    // MARK: - Initializers

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
             })
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Public Methods

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    func webViewClean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    // MARK: - IBAction

    @IBAction private func didTapBackButton(_ sender: Any?) {
        
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    
    // MARK: - Public Methods
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            
            authService.fetchOAuthToken(code) { result in
                switch result {
                case .success(let bearerToken):
                    let token = bearerToken
                    let isSuccess = KeychainWrapper.standard.set(token, forKey: "Auth token")
                    guard isSuccess else {
                        // ошибка
                        return
                    }
                    self.delegate?.webViewViewControllerDidCancel(self)
                    self.switchToSplashScreen()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    func switchToSplashScreen() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        // Cоздаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора.
        let splashScreenViewController = SplashScreenViewController()
        
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = splashScreenViewController
    }
    
    // MARK: - Private Methods
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
}
