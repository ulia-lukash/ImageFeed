//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Uliana Lukash on 01.09.2023.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    
    
}
