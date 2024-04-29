//
//  UITextField+Extension.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 31/01/2024.
//

import Foundation
import UIKit

extension UITextField {
    
    @IBInspectable var leftPadding: CGFloat {
        get { 0 }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var rightPadding: CGFloat {
        get { 0 }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            leftViewMode = .always
        }
    }
    
}
