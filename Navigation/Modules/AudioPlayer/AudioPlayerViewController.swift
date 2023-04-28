//
//  AudioPlayerViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 27.4.23..
//

import Foundation
import UIKit
import AVFoundation
import SnapKit

class AudioPlayerViewController: UIViewController {
    
    var coordinator: AudioPlayerCoordinator?
    
    private var audioPlayer: AVAudioPlayer?
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.addTarget(self, action: #selector(playPauseMusic), for: .touchUpInside)
        return button
    }()

    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "stop"), for: .normal)
        button.addTarget(self, action: #selector(stopMusic), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameMusic: UILabel = {
        let label = UILabel()
        label.text = "Queen"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.setupUI()
        self.settingPlayer()
    }
    
    private func settingPlayer() {
        do {
            guard let fileURL = Bundle.main.url(forResource: "Queen",
                                                withExtension: "mp3")
            else {
                assertionFailure("File not found")
                return
            }
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL, fileTypeHint: AVFileType.mp3.rawValue)
            
            audioPlayer?.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    private func setupUI() {
        view.addSubview(self.playPauseButton)
        view.addSubview(self.stopButton)
        view.addSubview(self.nameMusic)
        
        self.playPauseButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(50)
        }
        self.stopButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.right.equalTo(self.view.snp.right).inset(50)
        }
        
        self.nameMusic.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview()
        }
        
    }
    
    @objc private func playPauseMusic() {
        if let player = audioPlayer {
            if player.isPlaying == false {
                player.play()
                playPauseButton.setImage(UIImage(systemName: "pause"), for: .normal)
            }
            else if player.isPlaying == true {
                player.pause()
                playPauseButton.setImage(UIImage(systemName: "play"), for: .normal)
            }
        }
    }
    
    @objc private func stopMusic() {
        if let player = audioPlayer {
            if player.currentTime > 0 || player.isPlaying == true {
                player.pause()
                player.currentTime = 0
                playPauseButton.setImage(UIImage(systemName: "play"), for: .normal)
            }
            else if player.currentTime > 0 || player.isPlaying == false {
                player.currentTime = 0
            }
        }
    }
    
}
