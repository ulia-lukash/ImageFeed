//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 01.09.2023.
//

import Foundation
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    weak var delegate: ImagesListCellDelegate? 
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    static let reuseIdentifier = "ImagesListCell"
    
    func setIsLiked(isLiked: Bool) {
        let likeIndicatorImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeIndicatorImage, for: .normal)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}


