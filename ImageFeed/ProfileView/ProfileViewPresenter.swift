//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 12.11.2023.
//

import UIKit
import SwiftKeychainWrapper

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func exitProfile()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    private let webVVC = WebViewViewController()
    
    func exitProfile(){
        
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "Auth token")
        webVVC.webViewClean()
        guard let window = UIApplication.shared.windows.first else {fatalError("Invalid Configuration")}
        window.rootViewController = SplashScreenViewController()
        window.makeKeyAndVisible()
    }
}
