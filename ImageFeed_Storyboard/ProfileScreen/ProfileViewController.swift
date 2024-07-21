//
//  ProfileViewController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 06.07.2024.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Private Properties
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var nameLabel = createLabel(
        text: "Екатерина Новикова",
        color: .white,
        font: UIFont.systemFont(ofSize: 23, weight: .semibold)
    )
    
    private lazy var emailLabel = createLabel(
        text: "@ekaterina_nov",
        color: #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1) ,
        font: UIFont.systemFont(ofSize: 13)
    )
    
    private lazy var aboutMeLabel = createLabel(
        text: "Hello, World!",
        color: .white,
        font: UIFont.systemFont(ofSize: 13)
    )
    
    private lazy var profilePic = {
        let img = UIImageView()
        img.image = UIImage(named: "Userpic")
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var exitButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Exit"), for: .normal)
        btn.tintColor = #colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1)
        return btn
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupObserver()
        updateAvatar()
        updateProfileDetails(profile: profileService.profile)
        exitButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
        
    }
    
    
    //MARK: - Private Methods
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else {
            return
        }
        self.nameLabel.text = profile.name
        self.emailLabel.text = profile.loginName
        self.aboutMeLabel.text = profile.bio
    }
    
    private func setupObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil, // nil чтобы получать уведомление от любых источников
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profilePic.kf.indicatorType = .activity
        profilePic.kf.setImage(
            with: url,
            placeholder: UIImage(named: "UserpicStub"),
            options: [.processor(processor)]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    //MARK: - Private UI-Methods
    private func createLabel(
        text: String,
        color: UIColor,
        font: UIFont
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        return label
    }
    
    //MARK: - Private Methods
    func clearCookies() {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
    
    func clearWebsiteData() {
        let dataStore = WKWebsiteDataStore.default()
        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date(timeIntervalSince1970: 0)
        
        dataStore.removeData(ofTypes: dataTypes, modifiedSince: date) {
            print("Все данные WKWebsiteDataStore были очищены")
        }
    }
    
    @objc private func logoutButtonDidTap(_ sender: Any) {
        OAuth2TokenStorage.deleteToken()
        clearCookies()
        clearWebsiteData()
        
        let viewController = SplashViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    //MARK: - UI-SetUp
    private func setupViews(){
        view.backgroundColor = .ypBlack
        [nameLabel,
         aboutMeLabel,
         profilePic,
         exitButton,
         emailLabel,].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            profilePic.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            profilePic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 32),
            profilePic.widthAnchor.constraint(equalToConstant: 70),
            profilePic.heightAnchor.constraint(equalToConstant: 70),
            
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: profilePic.centerYAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: profilePic.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor,constant: 8),
            
            emailLabel.leadingAnchor.constraint(equalTo: profilePic.leadingAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 8),
            
            aboutMeLabel.leadingAnchor.constraint(equalTo: profilePic.leadingAnchor),
            aboutMeLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor,constant: 8),
            
        ])
    }
    
}
