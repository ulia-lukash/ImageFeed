//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Uliana Lukash on 12.11.2023.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var profileExited: Bool = false
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad(){
        viewDidLoadCalled = true
    }
    func exitProfile() {
        profileExited = true
    }
    
    
}
