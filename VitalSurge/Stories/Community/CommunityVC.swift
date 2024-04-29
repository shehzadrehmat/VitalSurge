//
//  CommunityVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 11/02/2024.
//

import UIKit
import iOSDropDown

class CommunityVC: UIViewController {
    
    private var allBlogs = [Blog]()
    private var blogs = [Blog]()
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var queryPicker: DropDown!
    
    private var queries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientView()
        
        queryPicker.didSelect { selectedText, index, id in
            if index == 0 {
                self.blogs = self.allBlogs
            } else {
                self.blogs = self.allBlogs.filter { $0.query == selectedText }
            }
            
            self.tableView.reloadData()
        }
        
        fetchBlogs()
        Task.init {
            if let queries = await FireStoreManager.shared.fetchQueries() {
                DispatchQueue.main.async {
                    self.queries = (["All"] + queries)
                    self.queryPicker.optionArray = self.queries
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(newBlogDidAdd), name: NSNotification.Name("NewBlog"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddBlogVCViewController {
            destination.queries = queries
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("NewBlog"), object: nil)
    }
    
    @objc private func newBlogDidAdd() {
        fetchBlogs()
    }
    
    private func fetchBlogs() {
        Task.init {
            if let blogs = await FireStoreManager.shared.fetchBlogs() {
                DispatchQueue.main.async {
                    self.blogs = blogs
                    self.allBlogs = blogs
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func openDetail(isReply: Bool, indexPath: IndexPath) {
        if let blogDetail = UIStoryboard.tab.instantiateViewController(withIdentifier: "BlogDetailVC") as? BlogDetailVC {
            blogDetail.blog = blogs[indexPath.item]
            blogDetail.isReply = isReply
            mainTabBar?.navigationController?.pushViewController(blogDetail, animated: true)
        }
    }
    
    @IBAction private func filterDidTap() {
        queryPicker.showList()
    }
    
}

extension CommunityVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommunityCell
        cell.configure(blog: blogs[indexPath.item], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetail(isReply: false, indexPath: indexPath)
    }
}

extension CommunityVC: CommunityCellProtocol {
    func replyDidPress(cell: CommunityCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        openDetail(isReply: true, indexPath: indexPath)
    }
    
    func cellDidPress(cell: CommunityCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        openDetail(isReply: false, indexPath: indexPath)
    }
}
