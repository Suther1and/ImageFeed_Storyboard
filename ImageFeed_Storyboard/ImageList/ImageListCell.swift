//
//  ImageListCell.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 06.07.2024.
//

import UIKit

final class ImageListCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    
    @IBOutlet var cellLabel: UILabel!
    
    @IBOutlet var likeButton: UIButton!
    
    static let reuseIdentifier = "ImageListCell"
}
