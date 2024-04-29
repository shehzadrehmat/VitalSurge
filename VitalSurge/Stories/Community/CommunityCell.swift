//
//  CommunityCell.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 14/02/2024.
//

import UIKit
import SDWebImage
import FirebaseStorage

protocol CommunityCellProtocol: NSObjectProtocol {
    func cellDidPress(cell: CommunityCell)
    func replyDidPress(cell: CommunityCell)
}

class CommunityCell: UITableViewCell {
    
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelText: UILabel!
    @IBOutlet private weak var labelDate: UILabel!
    @IBOutlet private weak var buttonComments: UIButton!
    @IBOutlet private weak var imageViewBlog: UIImageView!
    
    private weak var delegate: CommunityCellProtocol?
    
    func configure(blog: Blog, delegate: CommunityCellProtocol) {
        self.delegate = delegate
        labelName.text = blog.user.fullName
        labelDate.text = blog.dateAdded
        labelText.text = blog.description
        buttonComments.setTitle("Comments \(blog.comments)", for: .normal)
        imageViewBlog.isHidden = blog.image.isEmpty
        
        if !blog.image.isEmpty {
            let storageRef = Storage.storage().reference().child(blog.image)
            storageRef.downloadURL { [weak self] url, error in
                if let url {
                    self?.imageViewBlog.sd_setImage(with: url)
                }
            }
        }
    }
    
    @IBAction private func replyDidPress() {
        delegate?.replyDidPress(cell: self)
    }
    
    @IBAction private func commentDidPress() {
        delegate?.cellDidPress(cell: self)
    }
}
