//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 09.09.2023.
//

import Foundation
import UIKit
import Kingfisher
import SwiftKeychainWrapper

// MARK: - Types

public protocol ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func setProfile()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: - Public Properties
    
    var presenter: ProfileViewPresenterProtocol?
    // - Profile pic
    let profileImage = UIImage(named: "placeholder.svg")
    lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView(image: profileImage)
        return profileImageView
    }()
    // - Text labels
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White (iOS)")
        self.nameLabel = nameLabel
        return nameLabel }()
    
    lazy var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor(named: "YP Gray (iOS)")
        self.loginNameLabel = loginNameLabel
        return loginNameLabel }()
    
    lazy var profileBioLabel: UILabel = {
        let profileBioLabel = UILabel()
        profileBioLabel.text = "Hello, world!"
        profileBioLabel.textColor = UIColor(named: "YP White (iOS)")
        self.profileBioLabel = profileBioLabel
        return profileBioLabel }()
    // - Exit button
    lazy var profileExitButton: UIButton = {
        let profileExitButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapExitProfileButton)
        )
        profileExitButton.tintColor = UIColor(named: "YP Red (iOS)")
        return profileExitButton }()
    
    // MARK: - Private Properties
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let webVVC = WebViewViewController.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let username = self.profileService.profile?.username {
            self.profileImageService.fetchProfileImageURL(username: username) { _ in }
        }
        setProfile()
        presenter = ProfileViewPresenter()
    }
    
    // MARK: - ProfileViewControllerProtocol
    
    // - TODO: Разобрать Мегалодона на что-то более поворотливое... акулы-няньки?
    func setProfile() {
        
        
        addSubviews()
        updateProfileDetails(profile: profileService.profile)
        updateAvatar()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard self != nil else { return }
                updateAvatar()
            }
        
        func addSubviews() {
            view.addSubview(profileBioLabel)
            profileBioLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loginNameLabel)
            loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(profileImageView)
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(profileExitButton)
            profileExitButton.translatesAutoresizingMaskIntoConstraints = false
            
            setConstraints()
        }
        
        func setConstraints() {
            NSLayoutConstraint.activate([
                profileBioLabel.widthAnchor.constraint(equalToConstant: 77),
                profileBioLabel.heightAnchor.constraint(equalToConstant: 18),
                profileBioLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                profileBioLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
                loginNameLabel.widthAnchor.constraint(equalToConstant: 99),
                loginNameLabel.heightAnchor.constraint(equalToConstant: 18),
                
                loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                loginNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
                nameLabel.widthAnchor.constraint(equalToConstant: 241),
                nameLabel.heightAnchor.constraint(equalToConstant: 18),
                
                nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 154),
                profileImageView.widthAnchor.constraint(equalToConstant: 70),
                profileImageView.heightAnchor.constraint(equalToConstant: 70),
                
                profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
                profileExitButton.widthAnchor.constraint(equalToConstant: 44),
                profileExitButton.heightAnchor.constraint(equalToConstant: 44),
                
                profileExitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
                profileExitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            ])
        }
        
        
        func updateProfileDetails(profile: Profile?) {
            guard let profile = profile else {return}
            self.nameLabel.text = profile.name     // - полное имя
            self.loginNameLabel.text = profile.loginName // - @ username
            self.profileBioLabel.text = profile.bio
        }
        func updateAvatar() {
            guard
                let profileImageURL = profileImageService.avatarURL,
                let url = URL(string: profileImageURL) else { return }
            print(profileImageURL)
            let processor = RoundCornerImageProcessor(cornerRadius: 35)
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: url,
                                         placeholder: UIImage(named: "placeholder.svg"),
                                         options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
            let cache = ImageCache.default
            cache.clearDiskCache()
            cache.clearMemoryCache()
            
        }
    }
    
    // MARK: - Private Methods
    
    @objc
    
    private func didTapExitProfileButton() {
        let alert = UIAlertController(title: "Выход", message: "Выйти из Вашего профиля?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.exitProfile()
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        self.present(alert, animated: true)
    }
    
}



