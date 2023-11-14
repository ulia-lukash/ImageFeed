//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 04.10.2023.
//

import Foundation
import UIKit
import ProgressHUD
import SwiftKeychainWrapper

final class SplashScreenViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var isFirstLaunch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "YP Black (iOS)")
        self.addImage(view: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let token = KeychainWrapper.standard.string(forKey: "Auth token") else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {return}
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
            return
        }
        self.fetchProfile(token: token)
        switchToTabBarController()
        
    }
    
    private func addImage(view: UIView) {
        let image = UIImage(named: "Logo")
        let imageView = UIImageView(image: image)
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

extension SplashScreenViewController {
    
    private func switchToTabBarController() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        // Cоздаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора.
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
        
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.showAlertOAuth2Token(with: error)
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profile):
                // - TODO: вообще вот тут должен, наверное, вызываться метод добычи урлы аватарки, но что-то как-то моторчик не фыр-фыр
                //                self?.profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                print(profile)
            case .failure(let error):
                self?.showAlertProfile(with: error)
                break
            }
        }
    }
    
    
    
    private func showAlertProfile(with errorFetchProfile: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось получить Профиль пользователя",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertOAuth2Token(with errorFetchOAuth2Token: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось получить Токен",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
