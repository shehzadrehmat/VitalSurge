//
//  HealthProgramVC.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 17/02/2024.
//

import UIKit
import AVFoundation
import AVKit

class HealthProgramVC: UIViewController {
    
    @IBOutlet private weak var playerContainerView: UIView!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelHeading: UILabel!
    @IBOutlet private weak var buttonPlay: UIButton!
    
    var programDetailType: HealthProgram!
    
    var player: AVPlayer!
    
    private var isPlaying = true

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientView()
        setupVideo()
        setupTitle()
    }
    
    private func setupTitle() {
        let title: String
        switch(programDetailType) {
        case .back: title = "Back Pain"
        case .elbow: title = "Elbow Pain"
        case .feet: title = "Feet Pain"
        case .hand: title = "Hand Pain"
        default: title = ""
        }
        
        labelTitle.text = title
        labelHeading.text = title
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func setupVideo() {
        guard let path = Bundle.main.path(forResource: "hands", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        
        var playerLayer: AVPlayerLayer?
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer!.frame = playerContainerView.bounds
        
        playerContainerView.layer.addSublayer(playerLayer!)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
    
    @IBAction private func playDidPress() {
        isPlaying.toggle()
        isPlaying ? player.play() : player.pause()
        buttonPlay.isHidden = isPlaying
    }
 

}
