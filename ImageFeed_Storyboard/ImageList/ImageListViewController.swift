//
//  ViewController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 06.07.2024.
//

import UIKit

final class ImageListViewController: UIViewController {

    //MARK: - Private Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosNames: [String] = Array(0..<20).map{"\($0)"}
    
    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
    }

    //MARK: - Private Methods
    private func tableViewSetup() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    private func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosNames[indexPath.row]) else {
            return
        }
        cell.cellImage.image = image
        let date = Date()
        cell.dateLabel.text = date.dateTimeString
        
        let likedImage = UIImage(named: indexPath.row % 2 == 0 ? "HeartOn" : "HeartOff")
        cell.likeButton.setImage(likedImage, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let image = UIImage(named: photosNames[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

}

//MARK: - TableViewDelegate
extension ImageListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
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

//MARK: - TableViewDataSource
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photosNames.count {
            //TODO: Добавить функцию ImageListService.fetchPhotosNextPage
        }
    }
    
}
