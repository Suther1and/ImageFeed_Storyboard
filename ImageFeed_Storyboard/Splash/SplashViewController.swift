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
    private var alertPresenter: AlertPresenter?
    
    var delegate: AuthViewControllerDelegate?
    
    private let logoImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Vector")
        return img
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tokenCheck()
//        profileImageService.fetchProfileImageURL(username: username) { _ in }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: - Private Methods
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { return }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func tokenCheck() {
        if let token = oAuth2Storage.token {
            fetchProfile(token)
        } else {
            let vc = AuthViewController()
            vc.delegate = self
            
            alertPresenter = AlertPresenter(viewController: vc)
            
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: - UI-Methods
    func setupViews() {
        view.backgroundColor = UIColor(named: "bgColor")
        [logoImageView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
            logoImageView.heightAnchor.constraint(equalToConstant: 77.5)
        ])
    }
    
}

//MARK: - Extensions

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchProfile(code)
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                switchToTabBarController()
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(AuthServiceErrors.invalidResponse) - Ошибка получения данных профиля, \(error.localizedDescription)")
            }
        }
        
    }
    
    private func fetchOAuthToken(_ code: String){
        UIBlockingProgressHUD.show()
        oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                guard let token = oAuth2Storage.token else { return }
                fetchProfile(token)
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
