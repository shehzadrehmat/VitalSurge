//
//  FireStoreManager.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 14/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage

class FireStoreManager {
    
    static let shared = FireStoreManager()
    
    private let db = Firestore.firestore()
    private let ref = Database.database().reference()
    
    var loggedInUser: User?
    
    var blogs = [StorageReference]()
    var tips = [(String, String)]()
    
    private init() {
        Task.init {
            await self.fetchBlogsFolder()
            tips = await self.fetchHomeTips() ?? []
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                notificationCenter.post(name: NSNotification.Name(rawValue: "TipsFetched"), object: nil)
            }
        }
    }
    
    @discardableResult
    private func fetchHomeTips() async -> [(String, String)]? {
        do {
            let querySnapshot = try await db.collection("homeTips").getDocuments()
            
            var documents = querySnapshot.documents
            documents.sort(by: { Int($0.documentID) ?? 0 < Int($1.documentID) ?? 0 })
            
            return querySnapshot.documents.compactMap { blog in
                (blog.data()["title"] as? String ?? "", blog.data()["description"] as? String ?? "")
            }
        } catch {
            return nil
        }
    }
    
    private func fetchBlogsFolder() async {
        let storage = Storage.storage()
        let storageReference = storage.reference().child("blogs")
        do {
            let result = try await storageReference.listAll()
            blogs = result.items
        } catch {
          // ...
            print(error.localizedDescription)
        }
    }
    
    func loginUser(email: String) async -> Result<User?, Error>? {
        if let email = userDefaults.email {
            do {
                let querySnapshot = try await db.collection("user")
                                                    .whereField("email", isEqualTo: email)
                                                    .getDocuments()
                
                
                if let userRef = querySnapshot.documents.first {
                    let user = User(dict: userRef.data())
                    loggedInUser = user
                    return .success(user)
                } else {
                    return .failure(NSError(domain: "", code: 0) as Error)
                }
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func emailVerification(email: String, password: String) async -> Result<Bool, Error>? {
        do {
            let querySnapshot = try await db.collection("user")
                                                .whereField("email", isEqualTo: email)
                                                .whereField("password", isEqualTo: password)
                                                .getDocuments()
            
            
            if let userRef = querySnapshot.documents.first {
                loggedInUser = User(dict: userRef.data())
                userDefaults.saveUser(loggedInUser!.email, name: loggedInUser!.username)
            }
            
            return querySnapshot.documents.count > 0 ? .success(true) : .failure(NSError(domain: "", code: -1) as Error)
        } catch {
            return nil
        }
    }
    
    func socialVerification(googleToken: String?, appleToken: String?, user: User) async {
        do {
            let querySnapshot: QuerySnapshot
            if let appleToken {
                querySnapshot = try await db.collection("user")
                    .whereField("a_token", isEqualTo: appleToken)
                    .getDocuments()
            } else  {
                querySnapshot = try await db.collection("user")
                    .whereField("g_token", isEqualTo: googleToken!)
                    .getDocuments()
            }
            
            if(querySnapshot.documents.count == 0) {
                saveNewUser(user: user, appleToken: appleToken, googleToken: googleToken)
            }
            
            userDefaults.saveUser(user.email, name: user.username)
            
            
            if let userRef = querySnapshot.documents.first {
                loggedInUser = User(dict: userRef.data())
            }
            
        } catch {
        }
    }
    
    func createNewAccount(username: String, fullName: String, email: String, password: String) async -> Result<Bool, Error> {
        do {
            
            let querySnapshot = try await db.collection("user")
                .whereFilter(Filter.orFilter([
                    Filter.whereField("email", isEqualTo: email),
                    Filter.whereField("user_name", isEqualTo: username)
                ]))
                .getDocuments()
            
            
            if let userRef = querySnapshot.documents.first {
                return .failure(NSError(domain: "", code: -1))
            } else {
                saveNewUser(user: User(id: UUID().uuidString, email: email, password: password, fullName: fullName, userName: username), appleToken: nil, googleToken: nil) { error in
                }
                return .success(true)
            }
        } catch {
            return .failure(NSError(domain: "", code: -1))
        }
    }

    func uploadImage(image: UIImage, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        
        guard let data = image.jpegData(compressionQuality: 0.1) else { return }
        
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        
        let key = UUID().uuidString + ".jpeg"
        let mountainsRef = storageRef.child(key)
        
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload data and metadata
        _ = mountainsRef.putData(data, metadata: nil) { (metadata, error) in
            if let error {
                failure(error)
            } else {
                success(key)
            }
        }
        
    }
    
    func fetchQueries() async -> [String]? {
        do {
            let querySnapshot = try await db.collection("query").getDocuments()
            return querySnapshot.documents.compactMap { blog in
                blog.data()["title"] as? String ?? ""
            }
        } catch {
            return nil
        }
    }
    
    func fetchBlogs() async -> [Blog]? {
        do {
            let querySnapshot = try await db.collection("blogs").getDocuments()
            return querySnapshot.documents.compactMap { blog in
                Blog(data: blog.data(), docID: blog.documentID)
            }
        } catch {
            return nil
        }
        
    }
    
    func fetchComments(blog: Blog) async -> [BlogComment]? {
        do {
            let querySnapshot = try await db.collection("blogComments").whereField("blog_id", isEqualTo: blog.id).getDocuments()
            return querySnapshot.documents.compactMap { comment in
                BlogComment(data: comment.data(), docID: comment.documentID)
            }
        } catch {
            return nil
        }
    }
    
    func saveNewBlog(blog: Blog, completion: @escaping (Blog?) -> Void) {
        let blogsRef = db.collection("blogs")
        let newBlogRef = blogsRef.document()
        let blogData: [String: Any] = [
            "id": blog.id,
            "comments_count": blog.comments,
            "date_added": blog.dateAdded,
            "description": blog.description,
            "title": blog.title,
            "full_name": loggedInUser!.fullName,
            "image": blog.image,
            "query": blog.query,
            "user_id": loggedInUser!.id,
            "user_name": loggedInUser!.username
        ]
        
        newBlogRef.setData(blogData) { error in
            completion(error == nil ? blog : nil)
        }
    }
    
    private func saveNewUser(user: User, appleToken: String?, googleToken: String?, completion: ((Error?) -> Void)? = nil) {
        let commentRef = db.collection("user")
        let newCommentRef = commentRef.document()
        let userData = [
            "id": user.id,
            "email": user.email,
            "password": user.password,
            "gender": user.gender,
            "address": user.address,
            "city": user.city,
            "country": user.country,
            "a_token": appleToken ?? "",
            "g_token": googleToken ?? "",
            "user_name": user.username,
            "full_name": user.fullName
        ]
        
        newCommentRef.setData(userData) { [weak self] error in
            if error == nil, let self {
                Task.init {
                    await self.loginUser(email: user.email)
                }
            }
        }
    }
    
    func saveComment(comment: String, blog: Blog) {
        let commentRef = db.collection("blogComments")
        let newCommentRef = commentRef.document()
        
        // Create a dictionary with the comment data
        var commentData: [String: Any] = [
            "id": UUID().uuidString,
            "comment": comment,
            "blog_id": blog.id
        ]
        
        if let loggedInUser {
            commentData["user_id"] = loggedInUser.id
            commentData["full_name"] = loggedInUser.fullName
            commentData["user_name"] = loggedInUser.username
            commentData["user_email"] = loggedInUser.email
        }
        
        // Set the data for the new comment document
        newCommentRef.setData(commentData) { error in
            if let error = error {
                print("Error adding comment: \(error.localizedDescription)")
            } else {
                print("Comment added successfully!")
            }
        }
        
        let blogRef = db.collection("blogs").document(blog.documentID)
        blogRef.updateData(["comments_count": blog.comments + 1])
    }
    
}
