//
//  ImageListCell.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 06.07.2024.
//

import UIKit

final class ImageListCell: UITableViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "ImageListCell"
    
    //MARK: - @IBActions
    @IBAction func likeAction(_ sender: UIButton) {
        //TODO: - Обработать логику нажатия на кнопку 
    }
    
    //MARK: - @IBOutlets
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
    }
}
