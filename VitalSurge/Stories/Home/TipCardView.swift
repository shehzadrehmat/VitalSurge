//
//  TipCardView.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 17/02/2024.
//

import UIKit
import DragCardContainer

class TipCardView: DragCardView {
    
    @IBOutlet var labelCount: UILabel!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var labelRead: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var blogImageView: UIImageView!
    
    func configure(data: (String, String)) {
        labelTitle.text = data.0
        labelDescription.text = data.1
    }
    
}
