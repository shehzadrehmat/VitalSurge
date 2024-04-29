//
//  CommentCell.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 15/02/2024.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelReply: UILabel!
    @IBOutlet private weak var labelDate: UILabel!
    
    func configure(comment: BlogComment) {
        if !comment.dateAdded.isEmpty {
            labelDate.text = comment.dateAdded.replyDate
        }
        
        labelName.text = comment.user.fullName
        labelReply.text = comment.comment
    }
    
}
