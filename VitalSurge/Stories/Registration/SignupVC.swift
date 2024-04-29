//
//  SignupVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 18/02/2024.
//

import UIKit

class SignupVC: UIViewController {
    
    @IBOutlet private weak var textFieldEmail: UITextField!
    @IBOutlet private weak var textFieldPassword: UITextField!
    @IBOutlet private weak var textFieldUsername: UITextField!
    @IBOutlet private weak var textFieldFullName: UITextField!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var buttonSignup: UIButton!
    
    private lazy var appleWorker = AppleWorker()
    private lazy var googleWorker = GooglePlusWorker()
    
    private var isBusy = false

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @IBAction private func doSignup() {
        if let email = textFieldEmail.text,
           (email.count < 8 || !email.contains(".") || !email.contains("@")) {
            showMessageAlert(title: "Validation Error", message: "Please enter valid email")
            return
        }
        
        if let fullName = textFieldFullName.text,
           fullName.count < 5 {
            showMessageAlert(title: "Validation Error", message: "Please enter valid full name")
            return
        }
        
        if let username = textFieldUsername.text,
           username.count < 5 {
            showMessageAlert(title: "Validation Error", message: "Please enter valid username")
            return
        }
        
        if let password = textFieldPassword.text,
           !isPasswordValid(password) {
            showMessageAlert(title: "Validation Error", message: "Please enter the password with special character and 1 digit")
            return
        }
        
        isBusy = true
        showLoading(true)
        Task.init {
            let result = await FireStoreManager.shared.createNewAccount(username: textFieldUsername.text!, fullName: textFieldFullName.text!, email: textFieldEmail.text!, password: textFieldPassword.text!)
            switch result {
            case .success(_):
                appDelegate?.window?.rootViewController = UIStoryboard.tab.instantiateInitialViewController()
                
            case .failure(_):
                showLoading(false)
                showMessageAlert(title: "Error", message: "User already exist.")
            }
        }
        
    }
    
    @IBAction private func loginAppleDidPress() {
        if isBusy { return }
        showLoading(true)
        isBusy = true
        appleWorker.tryAuthorization(presentingViewController: self) {
            appDelegate?.window?.rootViewController = UIStoryboard.tab.instantiateInitialViewController()
        } failureBlock: { [weak self] error in
            self?.isBusy = false
            self?.showLoading(false)
            self?.showMessageAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    @IBAction private func loginGoogleDidPress() {
        if isBusy { return }
        showLoading(true)
        isBusy = true
        googleWorker.trySignInWith(nil, presentingViewController: self) {
            appDelegate?.window?.rootViewController = UIStoryboard.tab.instantiateInitialViewController()
        } failureBlock: { [weak self] error in
            self?.isBusy = false
            self?.showLoading(false)
            self?.showMessageAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    private func showLoading(_ showLoading: Bool) {
        spinner.isHidden = !showLoading
        buttonSignup.setTitle(showLoading ? "" : "Signup", for: .normal)
        showLoading ? spinner.startAnimating() : spinner.stopAnimating()
    }

}
