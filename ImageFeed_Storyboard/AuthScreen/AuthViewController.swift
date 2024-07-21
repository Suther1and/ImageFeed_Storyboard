//
//  AuthViewController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 15.07.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {

    //MARK: - Private Properties
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackButton()
     }
    
    //MARK: - Private Methods
    private func setUpBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward 1")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward 1")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "bgColor")
    }

}

//MARK: - Extensions
extension AuthViewController: WebViewControllerDelegate {
    
    func webViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    
}
