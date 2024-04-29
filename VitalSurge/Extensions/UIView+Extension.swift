//
//  UIView+Extension.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 31/01/2024.
//

import Foundation
import UIKit

extension UIView {
    
    class func viewFromNibName(_ name:String, bundle: Bundle = Bundle.main, viewIndex: Int = 0) -> UIView? {
        
        let views = bundle.loadNibNamed(name, owner: nil, options: nil) as? [UIView]
        
        if views?.count ?? 0 > viewIndex {
            return views?[viewIndex]
        } else {
            return views?.first
        }
    }
    
    class func viewFromNibClassName<T:UIView>(_ nibClassName:T.Type ,viewIndex: Int = 0) -> T {
        return viewFromNibName(classNameForNib(nibClassName), bundle: Bundle(for: nibClassName), viewIndex: viewIndex) as! T
    }

    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius  = newValue
            layer.masksToBounds = true
            clipsToBounds       = true
        }
    }
    
    @IBInspectable var yBorderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
                self.setNeedsDisplay()
            }
        }
        
        @IBInspectable var masksToBounds: Bool {
            get {
                return layer.masksToBounds
            }
            set {
                layer.masksToBounds = newValue
                self.setNeedsLayout()

            }
        }
        
        @IBInspectable var yborderColor: UIColor {
            get{ UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor) }
            set {
                layer.borderColor = newValue.cgColor
                self.setNeedsLayout()
            }
        }
    
  
    @IBInspectable
        var yShadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                self.clipsToBounds = false
                self.layer.shadowColor = UIColor.lightGray.cgColor
                self.layer.shadowOpacity = 1
                self.layer.shadowOffset = CGSize.zero
                self.layer.shadowRadius = newValue
            }
        }
        
        @IBInspectable
        var yShadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set {
                layer.shadowOffset = newValue
            }
        }
        
        @IBInspectable
        var yShadowColor: UIColor? {
            get {
                let color = UIColor(cgColor: layer.shadowColor!)
                return color
            }
            set {
                layer.shadowColor = newValue?.cgColor
            }
        }
    
}

extension UIViewController {
    
    var mainTabBar: AppTabController? {
        return parent as? AppTabController
    }
    
    
    @IBAction func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuDidPress() {
        mainTabBar?.showHideMenu()
    }
    
}

func classNameForNib(_ name:AnyClass) -> String {
    return name.self.description().components(separatedBy: ".").last!
}
