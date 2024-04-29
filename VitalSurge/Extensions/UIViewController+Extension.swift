//
//  UIViewController+Extension.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 17/02/2024.
//

import Foundation
import UIKit

typealias AppAction = (title: String, style: UIAlertAction.Style, onSelect: (UIAlertAction) -> Void)

extension UIViewController {
    
    func addGradientView() {
        
        if self.view.subviews.first?.tag == 2000 {
            self.view.subviews.first?.removeFromSuperview()
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: NSNotification.Name(rawValue: "ThemeDidChange"), object: nil)
        }
        
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 130))
        self.view.insertSubview(gradientView, at: 0)
        
        let imageView = UIImageView(image: UIImage(named: "theme\(themeIndex)"))
        gradientView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: gradientView.frame.size.height * 0.4, width: gradientView.frame.size.width, height: gradientView.frame.size.height * 0.6)
        
        gradientView.tag = 2000
      

        let colors = gradientColors
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.frame
    
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [NSNumber(integerLiteral: 0), NSNumber(integerLiteral: 1)]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    @objc private func themeDidChange(sender: Notification) {
        addGradientView()
    }
    

    func showMessageAlert(title: String?, message: String?) {
        showAlert(title: title, message: message, actions: [
            AppAction("Ok", .default, { _ in
                
            })
        ])
    }
    
    func showAlert(title: String?, message: String?, actions: [AppAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: action.onSelect)
            alertController.addAction(alertAction)
        }
    
        // For iPad, to avoid crash
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        present(alertController, animated: true, completion: nil)
    }
}
