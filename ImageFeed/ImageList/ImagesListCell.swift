//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 01.09.2023.
//

import Foundation
import UIKit

// MARK: - Types

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    var photos: [Photo] = []
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - IBOutlet
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    func setIsLiked(isLiked: Bool) {
        let likeIndicatorImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeIndicatorImage, for: .normal)
    }
    
    // MARK: - IBAction
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    } 
}


