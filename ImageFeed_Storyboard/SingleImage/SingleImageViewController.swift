//
//  SingleImageViewController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 06.07.2024.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        guard let image else {return}
        let share = UIActivityViewController(activityItems: [image],
                                             applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction private func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet private var singleImageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else {return}
            singleImageView.image = image
            if let image = image {
                rescaleAndCenterImageInScrollView(image: image)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = image
        
        if let image = image {
            rescaleAndCenterImageInScrollView(image: image)
        }
         scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
         
     }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
     

}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
        
    }
   
}
