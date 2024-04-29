//
//  EducationVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 11/02/2024.
//

import UIKit

class EducationVC: UIViewController {

    @IBOutlet private weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientView()
    }

}

extension EducationVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
