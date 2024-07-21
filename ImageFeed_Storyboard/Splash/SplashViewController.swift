//
//  SplashViewController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 16.07.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    //MARK: - Private Properties
    private let oAuth2Storage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let showAuthenticationScreenSegueIdentifier = "ShowAuth"
    private var alertPresenter: AlertPresenter?
    
    //MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tokenCheck()
        profileImageService.fetchProfileImageURL(username: username) { _ in }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: - Private Methods
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func tokenCheck() {
        if oAuth2Storage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    
}

//MARK: - Extensions
extension SplashViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        }else{
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = oAuth2Storage.token else {
            return
        }
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String){
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.switchToTabBarController()
                
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(AuthServiceErrors.invalidRequest) - Ошибка получения данных профиля, \(error.localizedDescription)")
                let alertModel = AlertModel(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    buttonTitle: "ОК",
                    buttonAction: nil
                )
                alertPresenter?.show(model: alertModel)
            }
        }
    }
}
