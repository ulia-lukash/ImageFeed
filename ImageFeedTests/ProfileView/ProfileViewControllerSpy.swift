//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Uliana Lukash on 12.11.2023.
//

import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    func setProfile() {
    }
    
    
}
