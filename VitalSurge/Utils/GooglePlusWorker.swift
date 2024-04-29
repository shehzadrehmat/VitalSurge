//
//  GooglePlusWorker.swift
//  Fayvo
//
//  Created by hst on 07/08/2019.
//  Copyright © 2019 Asif Bilal. All rights reserved.
//

import GoogleSignIn
import AppAuth

class GooglePlusWorker: NSObject {
    
    static let shared = GooglePlusWorker()
    
    struct SigninConfigurations {
        var clientID: String
        var serverClientID: String?
    }
    
    typealias SuccessHandler = () -> ()
    typealias FailureHandler = (_ error: Error) -> ()
    
    private let signInManager = GIDSignIn.sharedInstance
    
//    var currentTokenString: String? { signInManager.currentUser?.authentication.idToken}
    
    override init() {
        super.init()
    }
    
    func trySignInWith(_ configurations: SigninConfigurations?, presentingViewController: UIViewController,
                   success: @escaping SuccessHandler,
                   failureBlock failure: @escaping FailureHandler) {

        signInManager.signIn(withPresenting: presentingViewController) { [weak self] (user, error) in
            if let user = user?.user {
                if let self  {
                    Task.init {
                        await self.validateUser(userID: user.userID ?? "", email: user.profile?.email, name: user.profile?.name, success: success)
                    }
                }
            } else if let error {
                failure(error)
            } else {
                failure(NSError(domain: "", code: -1))
            }
        }
    }
    
    func signout() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    private func validateUser(userID: String, email: String?, name: String?, success: @escaping SuccessHandler) async {
        await FireStoreManager.shared.socialVerification(googleToken: userID, appleToken: nil, user: User(
            id: UUID().uuidString,
            email: email ?? "",
            fullName: name ?? "",
            userName: name?.lowercased().replacingOccurrences(of: " ", with: "_") ?? ""
        ))
        success()
    }
    
    // MARK: - Private Functions
    
    private func mapConfiruationsToGIDConfigurations(_ configurations: SigninConfigurations) -> GIDConfiguration {
        GIDConfiguration(clientID: configurations.clientID, serverClientID: configurations.serverClientID)
    }
}
