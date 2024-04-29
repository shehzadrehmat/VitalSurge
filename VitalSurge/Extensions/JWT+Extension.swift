//
//  JWT+Extension.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 17/02/2024.
//

import Foundation
import JWTDecode


extension String {
    
    func decodeToken() -> JWT? {
        return try? decode(jwt: self)
    }
}

extension JWT {
    
    func claimCustomUID() -> String? {
        return claim(name: "custom:uid").string
    }
    
    func claimPreferredUsername() -> String? {
        return claim(name: "preferred_username").string
    }
    
    func claimPhoneNumber() -> String? {
        return claim(name: "phone_number").string
    }
    
    func claimUser() -> String? {
        return claim(name: "user").string
    }
}
