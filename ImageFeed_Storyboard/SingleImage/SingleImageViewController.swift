//
//  SingleImageViewController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 06.07.2024.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else {return}
            singleImageView.image = image
        }
    }
    
    @IBAction private func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet private var singleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = image

     }
    

     

}
