//
//  AppleWorker.swift
//  Fayvo
//
//  Created by Asif Bilal on 27/07/2020.
//  Copyright © 2020 Asif Bilal. All rights reserved.
//

import AuthenticationServices
import JWTDecode


class AppleWorker: NSObject {
    
//    private let keychain = AppleKeychainItem()
    
    typealias SuccessHandler = () -> ()
    typealias FailureHandler = (_ error: Error) -> ()
    
    private weak var presentingViewController: UIViewController?
    private var successBlock: SuccessHandler?
    private var failureBlock: FailureHandler?
    
    var authorizationCode: String?
    
//    var currentUserIdentifier: String? {
//        return keychain.currentUserIdentifier
//    }
    
    func tryAuthorization(presentingViewController: UIViewController,
                          success: @escaping SuccessHandler,
                          failureBlock failure: @escaping FailureHandler) {
        
        self.presentingViewController = presentingViewController
        successBlock = success
        failureBlock = failure
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func validateUser(userIdentifier: String, email: String?, name: String?) async {
        await FireStoreManager.shared.socialVerification(googleToken: nil, appleToken: userIdentifier, user: User(
            id: UUID().uuidString,
            email: email ?? "",
            fullName: name ?? ""
        ))
        successBlock?()
    }

}

extension AppleWorker: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error: \(error.localizedDescription)")
        failureBlock?(error)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("authorization success: \(authorization.credential)")
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            if let authorizationCodeData = appleIDCredential.authorizationCode {
                authorizationCode = String(data: authorizationCodeData, encoding: .utf8)
            }
            
            let response = saveAppleIDCrendentialsIfNotAlready(appleIDCredential)
            Task.init {
                await validateUser(userIdentifier: response.0, email: response.2, name: response.1)
            }
            
            
        default:
            break
        }
    }
    
    private func saveAppleIDCrendentialsIfNotAlready(_ appleIDCredential: ASAuthorizationAppleIDCredential) -> (String, String, String?) {
        
        // Create an account in your system.
        let userIdentifier  = appleIDCredential.user
        
        var names = [String]()
        if let fullName = appleIDCredential.fullName {
            if let givenName    = fullName.givenName { names.append(givenName)}
            if let middleName   = fullName.middleName { names.append(middleName)}
            if let familyName   = fullName.familyName { names.append(familyName)}
        }
        
        var email = appleIDCredential.email
        
        // This code is intended to get email for those users which were authorized in previous versions of application.
        if email == nil,
           let authorizationIdentityTokenData = appleIDCredential.identityToken {
            let authorizationIdentityToken = String(data: authorizationIdentityTokenData, encoding: .utf8)
            email = authorizationIdentityToken?.decodeToken()?.claim(name: "email").string
        }
        
        return (userIdentifier, names.first ?? "", email)
    }
}

extension AppleWorker: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentingViewController?.view.window ?? (UIApplication.shared.delegate?.window ?? nil)  ?? UIWindow()
    }
}
