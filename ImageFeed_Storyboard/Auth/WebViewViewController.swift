//
//  WebViewViewController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 15.07.2024.
//

import UIKit
import WebKit

 

class WebViewViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet var webView: WKWebView!
     
    //MARK: - Private Properties
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthView()
      }
    

   //MARK: - URLComponents Setup
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("error in getting url string")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("error in getting url components")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }

}