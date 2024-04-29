//
//  Blog.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 14/02/2024.
//

import Foundation


struct Blog {
    var documentID: String
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var comments: Int
    var dateAdded: String
    var query: String
    var image: String
    var user: User
    
    init(data: [String: Any], docID: String) {
        documentID = docID
        id = data["id"] as? String ?? ""
        title = data["title"] as? String ?? ""
        description = data["description"] as? String ?? ""
        comments = data["comments_count"] as? Int ?? 0
        dateAdded = data["date_added"] as? String ?? ""
        query = data["query"] as? String ?? ""
        image = data["image"] as? String ?? ""
        user = User(
            id: data["user_id"] as? String ?? "",
            fullName: data["full_name"] as? String ?? "",
            userName: data["user_name"] as? String ?? ""
        )
    }
    
    init(title: String, description: String, query: String, image: String?) {
        documentID = ""
        id = UUID().uuidString
        self.title = title
        self.description = description
        comments = 0
        dateAdded = Date().ISO8601Format()
        self.query = query
        self.image = image ?? ""
        user = User(dict: [:])
    }
}

struct BlogComment {
    var documentID: String
    var id = UUID().uuidString
    var comment: String
    var user: User
    var dateAdded: String
    
    init(data: [String: Any], docID: String) {
        documentID = docID
        id = data["id"] as? String ?? ""
        comment = data["comment"] as? String ?? ""
        user = User(
            id: data["user_id"] as? String ?? "",
            fullName: data["full_name"] as? String ?? "",
            userName: data["user_name"] as? String ?? ""
        )
        dateAdded = data["date_added"] as? String ?? ""
    }
    
    init(comment: String) {
        documentID = ""
        self.comment = comment
        user = FireStoreManager.shared.loggedInUser!
        dateAdded = Date().ISO8601Format()
    }
}
