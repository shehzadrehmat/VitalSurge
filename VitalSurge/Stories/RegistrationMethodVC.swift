//
//  RegistrationMethodVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 18/02/2024.
//

import UIKit

class RegistrationMethodVC: UIViewController {
    
    lazy var appleLoginWorker = AppleWorker()
    lazy var googleLoginWorker = GooglePlusWorker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefaults.email != nil {
            appDelegate?.window?.rootViewController = UIStoryboard.tab.instantiateInitialViewController()
            Task.init {
                await validateUser()
            }
        }
    }
    
    @IBAction private func appleLoginDidPress() {
        appleLoginWorker.tryAuthorization(presentingViewController: self) {
            DispatchQueue.main.async {
                appDelegate?.window?.rootViewController = UIStoryboard.tab.instantiateInitialViewController()
            }
        } failureBlock: { [weak self] error in
            self?.showMessageAlert(title: "Error", message: error.localizedDescription)
        }

    }
    
    @IBAction private func googleLoginDidPress() {
        googleLoginWorker.trySignInWith(nil, presentingViewController: self) {
            DispatchQueue.main.async {
                
                appDelegate?.window?.rootViewController = UIStoryboard.tab.instantiateInitialViewController()
            }
        } failureBlock: { [weak self] error in
            self?.showMessageAlert(title: "Error", message: error.localizedDescription)
        }

    }
    
    private func validateUser() async {
        if let email = userDefaults.email {
            if let result = await FireStoreManager.shared.loginUser(email: email) {
                switch(result) {
                case .success(_):
                    print("true")
                    
                case .failure(_):
                    appDelegate?.window?.rootViewController = UIStoryboard.registration.instantiateInitialViewController()
                }
            }
        }
    }
   
}
