//
//  HealthVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 11/02/2024.
//

import UIKit
import SafariServices

enum HealthProgram {
    case feet, hand, elbow, back
}

class HealthVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientView()
    }
   
    @IBAction private func programDidPress(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        
        let url: String
        switch(tag) {
        case 0:
            url = "https://vitalsurge.com/product/ya-three-products"
            
        case 1:
            url = "https://vitalsurge.com/product/elbow-length-massager"
            
        default:
            url = "https://vitalsurge.com/product/enclosed-elbow-length"
        }
        
//        if let programDetailVC = UIStoryboard.tab.instantiateViewController(withIdentifier: "HealthProgramVC") as? HealthProgramVC {
//            programDetailVC.programDetailType = program
//            mainTabBar?.navigationController?.pushViewController(programDetailVC, animated: true)
//        }
        
        let safariVC = SFSafariViewController(url: URL(string: url)!)
        present(safariVC, animated: true, completion: nil)
    }
}
