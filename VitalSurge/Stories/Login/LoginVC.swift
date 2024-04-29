//
//  LoginVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 11/02/2024.
//

import UIKit
import AuthenticationServices

class LoginVC: UIViewController {
    
    @IBOutlet private weak var textFieldEmail: UITextField!
    @IBOutlet private weak var textFieldPassword: UITextField!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var buttonLogin: UIButton!
    
    private lazy var appleWorker = AppleWorker()
    private lazy var googleWorker = GooglePlusWorker()
    
    private var isBusy = false


    @IBAction private func loginDidPress() {
        if isBusy { return }
        if(textFieldEmail.text?.isEmpty ?? false) {
            showMessageAlert(title: "Validation", message: "Please enter the email")
        } else if(textFieldPassword.text?.isEmpty ?? false) {
            showMessageAlert(title: "Validation", message: "Please enter the password")
        } else {
            isBusy = true
            showLoading(true)
            Task.init {
                if let result = await FireStoreManager.shared.emailVerification(email: textFieldEmail.text!, password: textFieldPassword.text!) {
                    switch result {
                    case .success(_):
                        appDelegate?.window?.rootViewController = UIStoryboard.tab.instantiateInitialViewController()
                        
                    case .failure(_):
                        isBusy = false
                        showLoading(false)
                        showMessageAlert(title: "Error", message: "Cannot find the user with these credentials.")
                    }
                }
            }
        }
    }
    
    @IBAction private func loginAppleDidPress() {
        if isBusy { return }
        
        isBusy = true
        appleWorker.tryAuthorization(presentingViewController: self) {
            appDelegate?.window?.rootViewController = UIStoryboard.tab.instantiateInitialViewController()
        } failureBlock: { [weak self] error in
            self?.isBusy = false
            self?.showMessageAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    @IBAction private func loginGoogleDidPress() {
        if isBusy { return }
        
        isBusy = true
        googleWorker.trySignInWith(nil, presentingViewController: self) {
            appDelegate?.window?.rootViewController = UIStoryboard.tab.instantiateInitialViewController()
        } failureBlock: { [weak self] error in
            self?.isBusy = false
            self?.showMessageAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    private func showLoading(_ showLoading: Bool) {
        spinner.isHidden = !showLoading
        buttonLogin.setTitle(showLoading ? "" : "Login", for: .normal)
        showLoading ? spinner.startAnimating() : spinner.stopAnimating()
    }
    
}

