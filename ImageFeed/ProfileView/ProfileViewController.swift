//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 09.09.2023.
//

import Foundation
import UIKit


final class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var accountBio: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfilePicAndLogOutButton(view: self.view)
        addNameLabel(view: self.view)
        addUserName(view: self.view)
        addProfileBio(view: self.view)
        
    }
    
    @objc
        private func logOut() {
            
            }
    
}

func addProfilePicAndLogOutButton(view: UIView) {
    let profilePic = UIImage(named: "ProfilePic")
    let profileImageView = UIImageView(image: profilePic)
    
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(profileImageView)
    
    profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    
    profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
    
    let imageSize:CGSize = CGSize(width: 20, height: 22)
    
    let button = UIButton(type: UIButton.ButtonType.custom)
    button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: UIControl.State.normal)
    button.tintColor = UIColor(named: "YP Red (iOS)")
    button.imageEdgeInsets = UIEdgeInsets(
        top: (button.frame.size.height - imageSize.height) / 2,
        left: 16,
        bottom: (button.frame.size.height - imageSize.height) / 2,
        right: 8)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(button)
    
    button.widthAnchor.constraint(equalToConstant: 44).isActive = true
    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    button.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
}

func addNameLabel(view: UIView) {
    
    let label = UILabel()
    
    label.text = "Екатерина Новикова"
    label.font = UIFont.boldSystemFont(ofSize: 23)
    label.textColor = UIColor(named: "YP White (iOS)")

    label.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(label)
    
    label.widthAnchor.constraint(equalToConstant: 241).isActive = true
    label.heightAnchor.constraint(equalToConstant: 18).isActive = true
    
    label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    label.topAnchor.constraint(equalTo: view.topAnchor, constant: 154).isActive = true
}

func addUserName(view: UIView) {
    let label = UILabel()
    
    label.text = "@ekaterina_nov"
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = UIColor(named: "YP Gray (iOS)")
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(label)
    
    label.widthAnchor.constraint(equalToConstant: 99).isActive = true
    label.heightAnchor.constraint(equalToConstant: 18).isActive = true
    
    label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    label.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
}

func addProfileBio(view: UIView) {
    let label = UILabel()
    
    label.text = "Hello, world!"
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = UIColor(named: "YP White (iOS)")
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(label)
    
    label.widthAnchor.constraint(equalToConstant: 77).isActive = true
    label.heightAnchor.constraint(equalToConstant: 18).isActive = true
    
    label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    label.topAnchor.constraint(equalTo: view.topAnchor, constant: 206).isActive = true
}




