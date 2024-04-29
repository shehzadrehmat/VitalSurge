//
//  UserDefaults+Extension.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 18/02/2024.
//

import Foundation


extension UserDefaults {
    
//    func saveGoogleToken(_ token: String) {
//        set(token, forKey: "GoogleToken")
//        synchronize()
//    }
//
//    func saveGoogleToken(_ token: String) {
//        set(token, forKey: "GoogleToken")
//        synchronize()
//    }
    
    
    func saveUser(_ email: String?, name: String) {
        set(email, forKey: "Email")
        set(name, forKey: "Username")
        synchronize()
    }
    
    var email: String? {
        string(forKey: "Email")
    }
    
    var name: String? {
        string(forKey: "Username")
    }
    
    
    
}
