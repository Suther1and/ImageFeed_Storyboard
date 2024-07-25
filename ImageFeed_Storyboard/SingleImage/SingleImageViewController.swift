//
//  SingleImageViewController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 06.07.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    //MARK: - Private Properties
    var imageURL: URL? {
        didSet {
            guard isViewLoaded else {return}
            loadImage()
        }
    }
    
    //MARK: - @IBActions
    @IBAction func shareButtonPressed(_ sender: Any) {
        guard let image = singleImageView.image else {return}
        let share = UIActivityViewController(activityItems: [image],
                                             applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    //MARK: - @IBoutlets
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction private func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet private var singleImageView: UIImageView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        if let imageURL = imageURL {
            loadImage()
        }
    }
    
    //MARK: - Private Methods
    private func loadImage() {
        guard let imageURL = imageURL else { return }
        UIBlockingProgressHUD.show()
        singleImageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.singleImageView.image = imageResult.image
                self.singleImageView.frame.size = imageResult.image.size
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Что-то пошло не так. Попробовать ещё раз?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadImage()
        })
        present(alert, animated: true)
        
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

//MARK: - Extenstions
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let view = view else { return }
        
        let offsetX = max((scrollView.bounds.size.width - view.frame.size.width) / 2, 0)
        let offsetY = max((scrollView.bounds.size.height - view.frame.size.height) / 2, 0)
        
        UIView.animate(withDuration: 0.3) {
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        }
    }
}
