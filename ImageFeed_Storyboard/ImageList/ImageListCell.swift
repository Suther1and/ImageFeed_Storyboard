//
//  ImageListCell.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 06.07.2024.
//

import UIKit

final class ImageListCell: UITableViewCell {
    @IBAction func likeAction(_ sender: UIButton) {
    }
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    
    
    
    static let reuseIdentifier = "ImageListCell"
}
