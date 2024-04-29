//
//  FaqsCell.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 13/02/2024.
//

import UIKit

protocol FaqsCellDelegate: NSObjectProtocol {
    func openCloseDidPress(cell: FaqsCell)
}

struct FaqsModel {
    let title: String
    let description: String
    var isOpen: Bool
}

class FaqsCell: UITableViewCell {
    
    @IBOutlet private weak var buttonShowMoreLess: UIButton!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelDescription: UILabel!
    
    weak var delegate: FaqsCellDelegate?
    
    func configure(model: FaqsModel, delegate: FaqsCellDelegate) {
        self.delegate = delegate
        labelTitle.text         = model.title
        labelDescription.text   = model.description
        labelDescription.isHidden = !model.isOpen
        
        buttonShowMoreLess.setTitle(model.isOpen ? "-" : "+", for: .normal)
    }
    
    @IBAction private func openCloseDidPress() {
        delegate?.openCloseDidPress(cell: self)
    }
}
