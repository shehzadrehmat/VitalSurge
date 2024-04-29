//
//  AppTabController.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 11/02/2024.
//

import UIKit

class AppTabController: UIViewController {
    
    lazy private var homeVC: HomeVC = UIStoryboard(name: "Tab", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
    lazy private var communityVC: CommunityVC = UIStoryboard(name: "Tab", bundle: Bundle.main).instantiateViewController(withIdentifier: "CommunityVC") as! CommunityVC
    lazy private var healthVC: HealthVC  = UIStoryboard(name: "Tab", bundle: Bundle.main).instantiateViewController(withIdentifier: "HealthVC") as! HealthVC
    lazy private var educationVC: EducationVC = UIStoryboard(name: "Tab", bundle: Bundle.main).instantiateViewController(withIdentifier: "EducationVC") as! EducationVC
    lazy private var moodVC: MoodVC = UIStoryboard(name: "Tab", bundle: Bundle.main).instantiateViewController(withIdentifier: "MoodVC") as! MoodVC
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private var tabs: [UIButton]!
    
    @IBOutlet private weak var menuTrailingConstraint: NSLayoutConstraint!

    private var selectedTab = 0
    
    var topVC: UIViewController {
        let vc: UIViewController
        switch(selectedTab) {
            case 0: vc = homeVC
            case 1: vc = educationVC
            case 3: vc = communityVC
            case 4: vc = healthVC
            default: vc = homeVC
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchChild(vc: homeVC)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        _ = firebaseManager
    }
    
    @IBAction private func profileDidPress() {
        (menuTrailingConstraint.secondItem as? UIView)?.isHidden = true
        showHideMenu()
        
        let profileVC = UIStoryboard.menu.instantiateViewController(withIdentifier: "ProfileVC")
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction private func faqsDidPress() {
        (menuTrailingConstraint.secondItem as? UIView)?.isHidden = true
        showHideMenu()
    
        
        let faqsVC = UIStoryboard.menu.instantiateViewController(withIdentifier: "FaqsVC")
        navigationController?.pushViewController(faqsVC, animated: true)
    }
    
    @IBAction private func contactDidPress() {
        (menuTrailingConstraint.secondItem as? UIView)?.isHidden = true
        showHideMenu()
        
        let faqsVC = UIStoryboard.menu.instantiateViewController(withIdentifier: "ContactVC")
        navigationController?.pushViewController(faqsVC, animated: true)
    }
    
    @IBAction private func settingDidPress() {
        (menuTrailingConstraint.secondItem as? UIView)?.isHidden = true
        showHideMenu()
    }
    
    @IBAction private func logoutDidPress() {
        showAlert(title: "VitalSurge", message: "Are you sure you want to logout?", actions: [
            AppAction("Cancel", .default, { _ in
                
            }),
            
            AppAction("Logout", .default, { _ in
                userDefaults.saveUser(nil, name: "")
                appDelegate?.window?.rootViewController = UIStoryboard.registration.instantiateInitialViewController()
            })
        ])
    }
    
    @IBAction private func tabItemDidPress(sender: UIButton) {
        if selectedTab == sender.tag {
            return
        }
        
        tabs[selectedTab].tintColor = UIColor(named: "AppSecondaryGray")
        selectedTab = sender.tag
        tabs[selectedTab].tintColor = UIColor(named: "AppGreen")
        
        let vc: UIViewController
        switch(selectedTab) {
            case 0: vc = homeVC
            case 1: vc = educationVC
            case 3: vc = communityVC
            case 4: vc = healthVC
            default: vc = moodVC
        }
        switchChild(vc: vc)
    }
    
    private func switchChild(vc: UIViewController) {
        
        if let child = children.first {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        addChild(vc)
        containerView.addSubview(vc.view)
        vc.view.frame = containerView.bounds
        vc.didMove(toParent: self)
    }
    
    @IBAction func showHideMenu() {
        if(menuTrailingConstraint.constant < 0) {
            (menuTrailingConstraint.secondItem as? UIView)?.isHidden = false
        }
        
        menuTrailingConstraint.constant = menuTrailingConstraint.constant < 0 ? 0 : -UIScreen.main.bounds.size.width
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            if(self.menuTrailingConstraint.constant < 0) {
                (self.menuTrailingConstraint.secondItem as? UIView)?.isHidden = true
            }
        }

    }
    
}

extension AppTabController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

