//
//  WebViewViewController.swift
//  ImageFeed_Storyboard
//
//  Created by Pavel Barto on 15.07.2024.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate: AnyObject {
    func webViewController(_ vc: WebViewViewController, didAuthenticateWithCode: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet var progressView: UIProgressView!
    
    @IBOutlet var webView: WKWebView!
     
    //MARK: - Private Properties
    weak var delegate: WebViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
   
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthView()
        setupObserver()
      }
    
    //MARK: - Private Methods
    private func setupObserver() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
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

extension WebViewViewController: WKNavigationDelegate {
    
    private func code(from url: URL?) -> String? {
        if let url = url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == WebViewConstants.unsplashAuthorizeNativeURLString,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction.request.url) {
            delegate?.webViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow)
        }
    }
    
}
