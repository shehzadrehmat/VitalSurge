//
//  ABNibView.swift
//  Fayvo
//
//  Created by Shehzad Rehmat on 3/20/18.
//  Copyright © 2018 Shehzad Rehmat. All rights reserved.
//

import UIKit

class ABNibView: UIView {
    
    weak var heightConstraint: NSLayoutConstraint? {
        return constraints.filter { ($0.firstAttribute == .height && $0.firstItem as? UIView == self)}.first
    }
    
    weak var widthConstraint: NSLayoutConstraint? {
        return constraints.filter { ($0.firstAttribute == .width && $0.firstItem as? UIView == self)}.first
    }
    
    // MARK: - View life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @discardableResult
    func setupNib() -> Any? {
        let loadedView = UIView.viewFromNibClassName(type(of: self), viewIndex: tag)
        
        loadedView.frame = frame
        loadedView.autoresizingMask = autoresizingMask
        loadedView.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        loadedView.isHidden = isHidden
        loadedView.backgroundColor = backgroundColor
        loadedView.tag = tag
        loadedView.alpha = alpha
        addSelfConstraintsInView(loadedView)
        
        return loadedView
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        let selfView = super.awakeAfter(using: aDecoder) as? UIView
        
        if selfView?.subviews.count == 0 {
            let loadedView = UIView.viewFromNibClassName(type(of: self), viewIndex: tag)
            
            loadedView.frame = frame
            loadedView.autoresizingMask = autoresizingMask
            loadedView.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            loadedView.isHidden = isHidden
            loadedView.backgroundColor = backgroundColor
            loadedView.tag = tag
            loadedView.alpha = alpha
            addSelfConstraintsInView(loadedView)
            
            return loadedView
        }
        
        return selfView
    }
    
    private func addSelfConstraintsInView(_ loadedView: UIView) {
        
        for constraint in self.constraints {
            
            var firstItem = constraint.firstItem as! NSObject
            if firstItem == self { firstItem = loadedView }
            
            var secondItem = constraint.secondItem as? NSObject
            if secondItem == self { secondItem = loadedView}
            
            loadedView.addConstraint(NSLayoutConstraint(item: firstItem,
                                                        attribute: constraint.firstAttribute,
                                                        relatedBy: constraint.relation,
                                                        toItem: secondItem,
                                                        attribute: constraint.secondAttribute,
                                                        multiplier: constraint.multiplier,
                                                        constant: constraint.constant))
            
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        let loadedView = UIView.viewFromNibClassName(type(of: self), viewIndex: tag)
        loadedView.frame = bounds
        loadedView.isHidden = isHidden
        addSubview(loadedView)
        loadedView.getRunTimePropertiesForIB()
    }
    
    // MARK: - public functions
    
    func getRunTimePropertiesForIB() {
        layoutIfNeeded()
    }
    
}
