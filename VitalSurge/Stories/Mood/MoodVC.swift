//
//  MoodVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 13/03/2024.
//

import UIKit

class MoodVC: UIViewController {
    
    @IBOutlet private weak var topStackView: UIStackView!
    @IBOutlet private weak var bottomStackView: UIStackView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientView()

        selectedViewAt(themeIndex).backgroundColor = itemColor(index: themeIndex)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for label in topStackView.arrangedSubviews {
            label.cornerRadius = label.frame.size.width / 2
            label.yborderColor = itemColor(index: label.tag)
        }
        
        for label in bottomStackView.arrangedSubviews {
            label.cornerRadius = label.frame.size.width / 2
            label.yborderColor = itemColor(index: label.tag)
        }
    }
    
    
    @IBAction private func optionDidSelect(sender: UITapGestureRecognizer) {
        
        
        if sender.view?.tag == themeIndex { return }
        
        
        let selectedView = selectedViewAt(themeIndex)
        selectedView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        sender.view?.backgroundColor = itemColor(index: sender.view!.tag)
        themeIndex = sender.view!.tag
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ThemeDidChange"), object: nil)
        
    }
    
    private func selectedViewAt(_ index: Int) -> UIView {
        let selectedView: UIView
        if index < 4 {
            selectedView = topStackView.arrangedSubviews[index]
        } else {
            selectedView = bottomStackView.arrangedSubviews[index - 4]
        }
        
        return selectedView
    }
    
    private func itemColor(index: Int) -> UIColor {
        let color: UIColor
        switch(index) {
        case 0: color = UIColor(colorHex: 0x069AF3)
        case 1: color = UIColor(colorHex: 0x099864)
        case 2: color = UIColor(colorHex: 0xDC143C)
        case 3: color = UIColor(colorHex: 0xE0B0FD)
        case 4: color = UIColor(colorHex: 0xEF8001)
        case 5: color = UIColor(colorHex: 0x017B92)
        default: color = UIColor(colorHex: 0xE0115F)
        }
        return color
    }


}
