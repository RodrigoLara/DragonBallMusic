//
//  PlayerViewController.swift
//  MusicBattles
//
//  Created by Rodrigo Lara Ruano on 08/02/20.
//  Copyright © 2020 Rodrigo Lara Ruano. All rights reserved.
//

import UIKit
import AVKit
import RealmSwift

class PlayerViewController: UIViewController {

    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    var song: Song?
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var isPlay = false
    var seconds: Float64 = 0.0
    var timeObserver: Any?
    
    var duration: CMTime {
        return self.player!.currentItem!.asset.duration
    }
    
    let songs = Song.allObjects()
    var shuffleSongs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dragon Ball Play List"
        
        self.songImage.layer.cornerRadius = 8
        
        setupCustomNavigationBackButton()
        setupPlayer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let player = self.player, let observer = timeObserver else { return }

        player.removeTimeObserver(observer)
        self.player = nil
    }
    
    func setupPlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        guard let songObject = song else { return }

        self.songTitle.text = songObject.name
        self.songImage.image = UIImage(named: songObject.url.components(separatedBy: ".").first!)
        
        guard let url = FileManager.directoryUrl() else { return }
        
        let asset = AVURLAsset(url: url.appendingPathComponent(songObject.url))

        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        player?.volume = 1.0
        player?.allowsExternalPlayback = true

        currentTime.text = "00:00"
        totalTime.text = self.duration.description
        
        self.playerSlider.value = 0
        self.playerSlider.minimumValue = 0
        self.playerSlider.maximumValue = Float(self.duration.seconds)
        
        self.playButton.setImage(UIImage(named: "Pause"), for: .normal)
        self.isPlay = true
        player?.play()
        
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsedTime in
            self.updateSlider(elapsedTime: elapsedTime)
        })
    }
    
    func updateSlider(elapsedTime: CMTime) {
        let playerDuration = playerItemDuration()
        if CMTIME_IS_INVALID(playerDuration) {
            playerSlider.value = 0.0
            return
        }

        let currentTimePlayer = player?.currentItem?.currentTime()
        
        let duration = Float(CMTimeGetSeconds(currentTimePlayer!))
        if duration.isFinite && duration > 0 {
            currentTime.text = currentTimePlayer!.description

            let time = Float(CMTimeGetSeconds(elapsedTime))

            playerSlider.value = time
        }
    }

    private func playerItemDuration() -> CMTime {
        let thePlayerItem = player?.currentItem

        if thePlayerItem?.status == .readyToPlay {
            return thePlayerItem!.duration
        }

        return CMTime.invalid
    }

    private func seekToTime(_ seekTime: CMTime) {
        self.player?.seek(to: seekTime)
        self.currentTime.text = seekTime.description
    }
    
    //MARK: Actions
    
    @IBAction func play(_ sender: UIButton) {
        if player?.timeControlStatus == .playing {
            playButton.setImage(UIImage(named: "Play"), for: .normal)
            isPlay = false
            player?.pause()
        } else {
            playButton.setImage(UIImage(named: "Pause"), for: .normal)
            isPlay = true
            player?.play()
        }
    }
    
    @IBAction func previous(_ sender: UIButton) {
        guard let songObject = song, let songIndex = songs.index(of: songObject) else { return }
        
        if songIndex > 0 {
            song = songs[songIndex-1]
            
            setupPlayer()
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        guard let songObject = song, let songIndex = songs.index(of: songObject) else { return }

        if songIndex < songs.count-1 {
            song = songs[songIndex+1]
            
            setupPlayer()
        }
    }
    
    @IBAction func suffle(_ sender: UIButton) {
        if sender.isSelected {
            sender.tintColor = .black
        } else {
            sender.tintColor = #colorLiteral(red: 1, green: 0.6632423401, blue: 0, alpha: 1)
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func repeatPlaylist(_ sender: UIButton) {
        if sender.isSelected {
            sender.tintColor = .black
        } else {
            sender.tintColor = #colorLiteral(red: 1, green: 0.6632423401, blue: 0, alpha: 1)
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func changeSeekSlider(_ sender: UISlider) {
        let seekTime = CMTime(seconds: Double(sender.value), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.seekToTime(seekTime)
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        next(nextButton)
    }
}
