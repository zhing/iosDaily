//
//  AudioPlayerViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/14/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

let musicArray = ["http://zhing.qiniudn.com/%E5%B1%B1%E8%80%B3%E6%B9%BE.mp3",
                 "http://zhing.qiniudn.com/thanks.mp3",
                 "http://zhing.qiniudn.com/silent.mp3"]

class AudioPlayerViewController: UIViewController {
    var bkImageView :UIImageView!
    var playButton :UIButton!
    var player :AVPlayer!
    var playItemArray :[AVPlayerItem?]!
    var currentPlayIndex :Int!
    var currentPlayItem :AVPlayerItem!
    var slider :UISlider!
    var progressView :UIProgressView!
    var timeObserve :Any?
    
    var lastButton :UIButton!
    var nextButton :UIButton!
    
    deinit {
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "AudioPlayer"
        self.view.backgroundColor = UIColor.white
        
        player = AVPlayer()
        playItemArray = [AVPlayerItem?](repeating: nil, count: musicArray.count)
        setupSubViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAudioIndex(index: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        playFinished(forceFinish: true)
    }
    
    func setupSubViews() {
        bkImageView = UIImageView()
        let bkImage = UIImage(named: "musicBackground.jpg")
        bkImageView.image = bkImage
        self.view.addSubview(bkImageView)
        bkImageView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        playButton = UIButton.init(type: UIButtonType.custom)
        let imagePlay = UIImage(named:"play.png")?.reSizeImage(size: CGSize.init(width: 40, height: 40)).imageWithTintColor(tintColor: UIColor.white)
        let imagePause = UIImage(named:"pause.png")?.reSizeImage(size: CGSize.init(width: 40, height: 40)).imageWithTintColor(tintColor: UIColor.white)
        playButton.backgroundColor = UIColor.clear
        playButton.setImage(imagePlay, for: UIControlState.normal)
        playButton.setImage(imagePause, for: UIControlState.selected)
        playButton.imageView?.contentMode = UIViewContentMode.center
        playButton.addTarget(self, action: #selector(playAudio), for: UIControlEvents.touchUpInside)
        view.addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50, height: 50))
            make.bottom.equalTo(-30)
            make.centerX.equalTo(view)
        }
        
        progressView = UIProgressView()
        progressView.tintColor = UIColor.lightGray
        progressView.trackTintColor = UIColor.gray
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.height.equalTo(3)
            make.bottom.equalTo(-110)
        }
        
        slider = UISlider()
        slider.maximumTrackTintColor = UIColor.clear
        slider.setThumbImage(UIImage.roundedImageWithColor(fillColor: UIColor.white, size: CGSize.init(width: 20, height: 20), cornerRadius: 10), for: UIControlState.normal)
        slider.maximumValue = 0
        progressView.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        lastButton = UIButton.init(type: UIButtonType.custom)
        lastButton.tag = 19999
        let imageLast = UIImage(named:"last.png")?.reSizeImage(size: CGSize.init(width: 40, height: 40)).imageWithTintColor(tintColor: UIColor.white)
        lastButton.backgroundColor = UIColor.clear
        lastButton.setImage(imageLast, for: UIControlState.normal)
        lastButton.imageView?.contentMode = UIViewContentMode.center
        lastButton.addTarget(self, action: #selector(selectNext), for: UIControlEvents.touchUpInside)
        view.addSubview(lastButton)
        lastButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50, height: 50))
            make.bottom.equalTo(-30)
            make.trailing.equalTo(playButton.snp.leading).offset(-50)
        }
        
        nextButton = UIButton.init(type: UIButtonType.custom)
        nextButton.tag = 20001
        let imageNext = UIImage(named:"next.png")?.reSizeImage(size: CGSize.init(width: 40, height: 40)).imageWithTintColor(tintColor: UIColor.white)
        nextButton.backgroundColor = UIColor.clear
        nextButton.setImage(imageNext, for: UIControlState.normal)
        nextButton.imageView?.contentMode = UIViewContentMode.center
        nextButton.addTarget(self, action: #selector(selectNext), for: UIControlEvents.touchUpInside)
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50, height: 50))
            make.bottom.equalTo(-30)
            make.leading.equalTo(playButton.snp.trailing).offset(50)
        }
    }
    
    func setAudioIndex (index: Int) {
        if index < musicArray.count && index > 0 {
            currentPlayIndex = index
        } else {
            currentPlayIndex = 0
        }
        
        if playItemArray[currentPlayIndex] == nil {
            playItemArray[currentPlayIndex] = AVPlayerItem(url:URL(string:musicArray[currentPlayIndex])!)
        }
        currentPlayItem = playItemArray[currentPlayIndex]
        
        if player.currentItem != currentPlayItem {
            player.replaceCurrentItem(with: currentPlayItem)
        }
        
        initAVPlayItem()
    }
    
    func initAVPlayItem() {
        currentPlayItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        currentPlayItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
    }

    func addObserverForAVPlay() {
        timeObserve = player.addPeriodicTimeObserver(forInterval: CMTimeMake(Int64(1.0), Int32(1.0)), queue: DispatchQueue.main, using:{ (time) in
            let current = CMTimeGetSeconds(time)
            self.setPlayProgress(playTime: Float(current))
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(playFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: false)
    }
    
    func playAudio(sender: UIButton) {
        if sender.isSelected {
            player.pause()
            sender.isSelected = false
        } else {
            player.play()
            sender.isSelected = true
        }
    }
    
    func play() {
        player.play()
        addObserverForAVPlay()
        playButton.isSelected = true
    }
    
    func playFinished(forceFinish: Bool) {
        if forceFinish {
            player.pause()
        }
        
        progressView.progress = 0
        slider.value = 0
        slider.maximumValue = 0
        playButton.isSelected = false
        
        currentPlayItem.removeObserver(self, forKeyPath: "status")
        currentPlayItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        if timeObserve != nil {
            player.removeTimeObserver(timeObserve!)
            timeObserve = nil
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func selectNext(sender :UIButton?) {
        playFinished(forceFinish: true)
        
        if sender?.tag == 19999 {
            setAudioIndex(index: (currentPlayIndex - 1) % musicArray.count)
        } else if sender?.tag == 20001 {
            setAudioIndex(index: (currentPlayIndex + 1) % musicArray.count)
        }
    }
    
    // 计算缓冲进度
    func availableDuration() -> Float {
        let loadedTimeRanges = currentPlayItem.loadedTimeRanges
        let timeRange :CMTimeRange = loadedTimeRanges.first as! CMTimeRange
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSeconds = CMTimeGetSeconds(timeRange.duration)
        
        let totalDuration = CMTimeGetSeconds(currentPlayItem.duration)
        return Float(startSeconds + durationSeconds)/Float(totalDuration)
    }
    
    //
    func setCacheProgress(bufferPercent: Float) {
        progressView.setProgress(bufferPercent, animated: true)
    }
    
    func setPlayProgress(playTime: Float) {
        if slider.maximumValue == 0.0 {
            if CMTIME_IS_VALID(currentPlayItem.duration) {
                slider.maximumValue = Float(CMTimeGetSeconds(currentPlayItem.duration))
            }
        }
        slider.value = playTime
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status" {
            switch player.status {
                case AVPlayerStatus.unknown:
                    print("unknown")
                case AVPlayerStatus.readyToPlay:
                    print("readyToPlay")
                    self.play()
                case AVPlayerStatus.failed:
                    print("failed")
            }
        } else if keyPath == "loadedTimeRanges" {
            let percent = availableDuration()
            setCacheProgress(bufferPercent: percent)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
