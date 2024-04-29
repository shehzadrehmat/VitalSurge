//
//  HomeBlogDetailVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 21/02/2024.
//

import UIKit
import WebKit
import FirebaseStorage

class HomeBlogDetailVC: UIViewController {
    
    @IBOutlet private weak var webViewContainer: UIView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientView()
        addWebView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func addWebView() {
        
        if(index == -1) {
            guard let url = URL(string: "https://www.vitalsurge.com") else { return }
            setupWebView(url)
        } else {
            
            let documentRef = Storage.storage().reference().child("blogs").child("Blogs\(index + 1).docx")
            documentRef.downloadURL { [weak self] url, error in
                if let self, let url {
                    webViewContainer.isHidden = false
                    setupWebView(url)
                }
            }
            
            let imageRef = Storage.storage().reference().child("blogs").child("Blog\(index + 1).jpg")
            imageRef.downloadURL { [weak self] url, error in
                if let self, let url {
                    imageView.isHidden = false
                    imageView.sd_setImage(with: url)
                }
            }
        }
        
        
    }
    
    private func setupImage(_ url: URL) {
        var urlString = url.absoluteString
        urlString = urlString.replacingOccurrences(of: "Blogs\(index).docx", with: "Blog\(index).jpg")
        
        guard let imageURL = URL(string: urlString) else { return }
        imageView.sd_setImage(with: imageURL)
    }
    
    
    private func loginToWebsite(_ webView: WKWebView) {
        // Inject JavaScript to populate and submit the login form
        let username = "kyle"
        let password = "kyle123@#"
        
        let javaScript = """
                var inputs = document.getElementsByTagName('input');
                for (var i = 0; i < inputs.length; ++i) {
                    if (inputs[i].type.toLowerCase() === 'text' || inputs[i].type.toLowerCase() === 'email') {
                        inputs[i].value = '\(username)';
                    }
                    if (inputs[i].type.toLowerCase() === 'password') {
                        inputs[i].value = '\(password)';
                    }
                }
                """
        
        webView.evaluateJavaScript(javaScript) { (result, error) in
            if let error = error {
                print("Error injecting JavaScript: \(error.localizedDescription)")
            }
        }
    }
 
    private func setupWebView(_ url: URL) {
        let webView = WKWebView(frame: self.webViewContainer.bounds)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.webViewContainer.addSubview(webView)
        webView.load(URLRequest(url: url))
    }
    
}

extension HomeBlogDetailVC: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        webView.scrollView.setZoomScale(6.0, animated: false)
        
        if(index == -1) {
//            loginToWebsite(webView)
        }
    }
}
