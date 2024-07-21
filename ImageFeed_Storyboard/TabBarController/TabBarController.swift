//
//  TabBarController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 21.07.2024.
//

import UIKit


final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyBoard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "ProfileA"),
            selectedImage: nil
        )
        
        viewControllers = [imagesListViewController, profileViewController]
    }
    
}
