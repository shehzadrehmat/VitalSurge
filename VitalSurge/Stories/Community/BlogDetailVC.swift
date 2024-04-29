//
//  BlogDetailVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 15/02/2024.
//

import UIKit

class BlogDetailVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var replyTextField: UITextField!
    
    var blog: Blog!
    var isReply: Bool!

    private var comments = [BlogComment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if isReply {
            replyTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task.init {
            if let comments = await FireStoreManager.shared.fetchComments(blog: blog) {
                DispatchQueue.main.async {
                    self.comments = comments
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        bottomConstraint.constant = 10
    }
    
    @IBAction private func postDidPress() {
        if let text = replyTextField.text, !text.isEmpty {
            
            replyTextField.resignFirstResponder()
            view.endEditing(true)
            replyTextField.text = ""
            
            comments.insert(BlogComment(comment: text), at: 0)
            tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .none)
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            FireStoreManager.shared.saveComment(comment: text, blog: blog)
        }
    }
    
}

extension BlogDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment") as! CommentCell
        cell.configure(comment: comments[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
