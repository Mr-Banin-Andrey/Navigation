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
    
    //MARK: - Properties
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
    
    private lazy var nameSong: UILabel = {
        let label = UILabel()
        label.text = Songs().songs[anyIndex].name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nextSong: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        button.addTarget(self, action: #selector(nextMusic), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousSong: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        button.addTarget(self, action: #selector(previousMusic), for: .touchUpInside)
        return button
    }()
    
    private lazy var pictureAlbum: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "picturesAlbum")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 50
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var anySong = Bundle.main.url(forResource: "",
                                          withExtension: "")
    
    private var anyIndex = 0
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.setupUI()
        
        self.settingsSongs(name: Songs().songs[0].name, format: Songs().songs[0].format)
        self.settingPlayer()
        
    }

    //MARK: - Methods
    private func settingPlayer() {
        do {
            
            guard let fileURL = anySong
            else {
                assertionFailure("File not found")
                return
            }
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL, fileTypeHint: AVFileType.mp3.rawValue)
            
        } catch {
            print(error)
        }
    }
    
    private func setupUI() {
        
        view.addSubview(self.pictureAlbum)
        view.addSubview(self.nameSong)
        view.addSubview(self.buttonsStackView)
        self.buttonsStackView.addArrangedSubview(self.previousSong)
        self.buttonsStackView.addArrangedSubview(self.playPauseButton)
        self.buttonsStackView.addArrangedSubview(self.stopButton)
        self.buttonsStackView.addArrangedSubview(self.nextSong)
        
        self.pictureAlbum.snp.makeConstraints { maker in
            maker.width.equalTo(250)
            maker.height.equalTo(250)
            maker.centerX.equalToSuperview()
            maker.centerY.equalTo(self.view.snp.centerY).offset(-100)
        }
        
        self.nameSong.snp.makeConstraints { maker in
            maker.top.equalTo(self.pictureAlbum.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
        
        self.buttonsStackView.snp.makeConstraints { maker in
            maker.top.equalTo(self.nameSong.snp.bottom).offset(25)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func settingsSongs(name: String, format: String) {
        
        anySong = Bundle.main.url(forResource: name,
                                  withExtension: format)
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
                player.stop()
                player.currentTime = 0
                playPauseButton.setImage(UIImage(systemName: "play"), for: .normal)
            }
            else if player.currentTime > 0 || player.isPlaying == false {
                player.currentTime = 0
                player.stop()
            }
        }
    }
    
    @objc private func nextMusic() {
       
        if audioPlayer?.isPlaying == true {
            
            if anyIndex == 4  {
                anyIndex = 0
                self.settingsSongs(name: Songs().songs[anyIndex].name, format: Songs().songs[anyIndex].format)
                self.settingPlayer()
                self.nameSong.text = Songs().songs[anyIndex].name
                audioPlayer?.play()
                
            } else {
                anyIndex += 1
                self.settingsSongs(name: Songs().songs[anyIndex].name, format: Songs().songs[anyIndex].format)
                self.settingPlayer()
                self.nameSong.text = Songs().songs[anyIndex].name
                audioPlayer?.play()
            }
        } else {
            
            if anyIndex == 4  {
                anyIndex = 0
                self.settingsSongs(name: Songs().songs[anyIndex].name, format: Songs().songs[anyIndex].format)
                self.settingPlayer()
                self.nameSong.text = Songs().songs[anyIndex].name
                
            } else {
                anyIndex += 1
                self.settingsSongs(name: Songs().songs[anyIndex].name, format: Songs().songs[anyIndex].format)
                self.settingPlayer()
                self.nameSong.text = Songs().songs[anyIndex].name
            }
        }
    }
    
    @objc private func previousMusic() {
       
        if audioPlayer?.isPlaying == true {
            
            if anyIndex == 0 {
                anyIndex = 4
                self.settingsSongs(name: Songs().songs[anyIndex].name, format: Songs().songs[anyIndex].format)
                self.settingPlayer()
                self.nameSong.text = Songs().songs[anyIndex].name
                audioPlayer?.play()
                        
            } else {
                anyIndex -= 1
                self.settingsSongs(name: Songs().songs[anyIndex].name, format: Songs().songs[anyIndex].format)
                self.settingPlayer()
                self.nameSong.text = Songs().songs[anyIndex].name
                audioPlayer?.play()
 
            }
        } else {
            if anyIndex == 0 {
                anyIndex = 4
                self.settingsSongs(name: Songs().songs[anyIndex].name, format: Songs().songs[anyIndex].format)
                self.settingPlayer()
                self.nameSong.text = Songs().songs[anyIndex].name

            } else {
                anyIndex -= 1
                self.settingsSongs(name: Songs().songs[anyIndex].name, format: Songs().songs[anyIndex].format)
                self.settingPlayer()
                self.nameSong.text = Songs().songs[anyIndex].name

            }
        }
        
    }
}
