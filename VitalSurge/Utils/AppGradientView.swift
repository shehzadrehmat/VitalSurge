//
//  AppGradientView.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 12/03/2024.
//

import UIKit

var themeIndex = 0
var gradientColors: [CGColor] {
    let colors: [CGColor]
    switch(themeIndex) {
    case 0:
        colors = [UIColor(colorHex: 0x069AF3, alpha: 0.27).cgColor,
                  UIColor(colorHex: 0x069AF3, alpha: 1).cgColor]
        
    case 1:
        colors = [UIColor(colorHex: 0x00A86B, alpha: 0.27).cgColor,
                  UIColor(colorHex: 0x099864).cgColor]
        
    case 2:
        colors = [UIColor(colorHex: 0xDC143C, alpha: 0.27).cgColor,
                  UIColor(colorHex: 0xDC143C).cgColor]
        
    case 3:
        colors = [UIColor(colorHex: 0xE0B0FD, alpha: 0.27).cgColor,
                  UIColor(colorHex: 0xE0B0FD).cgColor]
        
    case 4:
        colors = [UIColor(colorHex: 0xEF8001, alpha: 0.27).cgColor,
                  UIColor(colorHex: 0xEF8001).cgColor]
        
    case 5:
        colors = [UIColor(colorHex: 0x017B92, alpha: 0.216).cgColor,
                  UIColor(colorHex: 0x017B92).cgColor]
        
    case 6:
        colors = [UIColor(colorHex: 0xE0115F, alpha: 0.216).cgColor,
                  UIColor(colorHex: 0xE0115F, alpha: 0.8).cgColor]
        
    default:
        colors = [UIColor(colorHex: 0xE0115F, alpha: 0.216).cgColor,
                  UIColor(colorHex: 0xE0115F, alpha: 0.8).cgColor]
        
    }
    
    return colors
}

@IBDesignable class AppGradientView: ABNibView {
    
    
    
//    override func draw(_ rect: CGRect) {
////        setupGradientLayer()
//    }
    
    
//    private func setupGradientLayer() {
//        
//        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
//            gradientLayer.removeFromSuperlayer()
//        }
//        
//        let colors = gradientColors
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [colors.first!, colors.last!]
//        gradientLayer.startPoint = .zero
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        layer.insertSublayer(gradientLayer, at: 0)
//    }
    

}
