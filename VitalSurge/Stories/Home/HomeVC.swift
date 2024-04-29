//
//  HomeVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 11/02/2024.
//

import UIKit
import Lottie
import DragCardContainer
import SafariServices
import FirebaseStorage

class HomeVC: UIViewController {
    
    @IBOutlet private weak var lottieView: LottieAnimationView!
    @IBOutlet private weak var tipContainerView: DragCardContainer!
    
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradientView()
        lottieView.contentMode  = .scaleAspectFill
        lottieView.loopMode     = .loop
        lottieView.play()
        
        labelTime.text = Date().ISO8601Format().replyDate
        labelName.text = "Welcome \(userDefaults.name ?? "")"
        
        notificationCenter.addObserver(self, selector: #selector(homeBlogsFetched), name: NSNotification.Name(rawValue: "TipsFetched"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? HomeBlogDetailVC {
            if segue.identifier == "product" {
                detail.index = -1
            } else {
                detail.index = sender as! Int
            }
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self, name: NSNotification.Name(rawValue: "TipsFetched"), object: nil)
    }
    
    @objc private func homeBlogsFetched() {
        setupCardContainer()
    }
    
    private func setupCardContainer() {
        tipContainerView.delegate   = self
        tipContainerView.dataSource = self
        
        tipContainerView.visibleCount = 3
        tipContainerView.infiniteLoop = true
        
        let mode = ScaleMode()
        mode.direction = .right
        mode.cardSpacing = 10
        tipContainerView.mode = mode
    }
    
    @IBAction private func popMenu() {
        mainTabBar?.showHideMenu()
    }
    
    @IBAction private func openProduct() {
        let safariVC = SFSafariViewController(url: URL(string: "https://www.vitalsurge.com")!)
        present(safariVC, animated: true, completion: nil)
    }
    
}

extension HomeVC: DragCardDataSource, DragCardDelegate {
    func numberOfCards(_ dragCard: DragCardContainer) -> Int {
        firebaseManager.tips.count
    }
    
    func dragCard(_ dragCard: DragCardContainer, viewForCard index: Int) -> DragCardView {
        let card = Bundle.main.loadNibNamed("TipCardView", owner: nil)?.first as! TipCardView
        
        func setTheme(color: UIColor) {
            card.labelDescription.textColor = color
            card.labelTitle.textColor = color
            card.labelCount.textColor = color
            card.labelRead.textColor = color
            card.icon.tintColor = color
        }
  
        card.backgroundColor = UIColor.green
        card.labelCount.text = "\(index + 1)/\(Int(firebaseManager.blogs.count/2))"
//        card.configure(data: firebaseManager.tips[index])
        
        let storageRef = Storage.storage().reference().child("blogs").child("Blog\(index + 1).jpg")
        storageRef.downloadURL { [weak card] url, error in
            if let url {
                card?.blogImageView.sd_setImage(with: url)
            }
        }
        
//        setTheme(color: .white)
//        if index % 3 == 0 {
//            card.backgroundColor = UIColor(red: 140/255, green: 221/255, blue: 184/255, alpha: 1)
//        } else if index % 3 == 1 {
//            card.backgroundColor = UIColor(red: 175/255, green: 239/255, blue: 210/255, alpha: 1)
//        } else {
//            card.backgroundColor = UIColor(red: 190/255, green: 250/255, blue: 240/255, alpha: 1)
//            setTheme(color: .black)
//        }
        
        return card
    }
    
    func dragCard(_ dragCard: DragCardContainer, didSelectTopCardAt index: Int, with cardView: DragCardView) {
        performSegue(withIdentifier: "detail", sender: index)
    }
}
