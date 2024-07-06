//
//  ViewController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 06.07.2024.
//

import UIKit

class ImageListViewController: UIViewController {

    private let photosNames: [String] = Array(0..<20).map{"\($0)"}
    
    @IBOutlet private var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }

    
    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosNames[indexPath.row]) else {
            return
        }
        cell.cellImage.image = image
        let date = Date()
        cell.cellLabel.text = date.dateTimeString
        
        let isLiked = indexPath.row % 2 == 0
        let likedImage = isLiked ? UIImage(named: "HeartOn") : UIImage(named: "HeartOff")
        cell.likeButton.setImage(likedImage, for: .normal)
    }

}

extension ImageListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let image = UIImage(named: photosNames[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImageListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    
}
