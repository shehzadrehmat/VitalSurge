//
//  User.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 14/02/2024.
//

import Foundation

struct User {
    let id: String
    let email: String
    let password: String
    let address: String
    let city: String
    let country: String
    let gender: String
    let fullName: String
    let username: String
    
    init(id: String = "", email: String = "",password: String = "", address: String = "",city: String = "", country: String = "",gender: String = "", fullName: String = "", userName: String = "") {
        self.id         = id
        self.email      = email
        self.address    = address
        self.password   = password
        self.city       = city
        self.country    = country
        self.gender     = gender
        self.fullName   = fullName
        self.username   = userName
    }
    
    init(dict: [String: Any]?) {
        id          = dict?["id"] as? String ?? ""
        email       = dict?["email"] as? String ?? ""
        password    = dict?["password"] as? String ?? ""
        address     = dict?["address"] as? String ?? ""
        city        = dict?["city"] as? String ?? ""
        country     = dict?["country"] as? String ?? ""
        gender      = dict?["gender"] as? String ?? ""
        fullName    = dict?["full_name"] as? String ?? ""
        username    = dict?["user_name"] as? String ?? ""
    }
    
}
