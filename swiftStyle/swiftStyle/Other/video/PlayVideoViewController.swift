//
//  PlayVideoViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/14/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import Jukebox

let audioURL = "http://zhing.qiniudn.com/%E5%B1%B1%E8%80%B3%E6%B9%BE.mp3"
let audioURL2 = "https://dn-zhing.qbox.me/%E5%B1%B1%E8%80%B3%E6%B9%BE.mp3"

class PlayVideoViewController: UIViewController {
    var button01 :UIButton!
    var button02 :UIButton!
    var player :AVPlayer!
    var audioPlayer :AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "palyVideo"
        self.view.backgroundColor = UIColor.white
        setupSubViews()
    }
    
    func setupSubViews() {
        button01 = UIButton.init(type: UIButtonType.custom)
        button01.setTitle("local", for: UIControlState.normal)
        button01.titleLabel?.textAlignment = NSTextAlignment.center
        button01.backgroundColor = UIColor.lightGray
        button01.addTarget(self, action: #selector(loadLocalAudio), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button01)
        button01.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.leading.equalTo(20)
            make.top.equalTo(100)
        }
        
        button02 = UIButton.init(type: UIButtonType.custom)
        button02.setTitle("remote", for: UIControlState.normal)
        button02.titleLabel?.textAlignment = NSTextAlignment.center
        button02.backgroundColor = UIColor.lightGray
        button02.addTarget(self, action: #selector(loadRemoteAudio), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button02)
        button02.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.leading.equalTo(20)
            make.top.equalTo(button01.snp.bottom).offset(20)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        _ = startMediaBrowserFromViewController(viewController: self, usingDelegate: self)
//        _ = startCameraFromViewController(viewController: self, withDelegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLocalAudio() {
        do {
            let soundFile = URL.init(fileURLWithPath: Bundle.main.path(forResource: "山耳湾", ofType: "mp3")!)
            audioPlayer = try AVAudioPlayer(contentsOf: soundFile)
            guard audioPlayer != nil else {
                return
            }
            
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func loadRemoteAudio() {
        player = AVPlayer(url: URL(string: audioURL2)!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        
        player!.play()
        
//        let jukebox = Jukebox(delegate: nil, items: [
//            JukeboxItem(URL: URL(string: audioURL)!),
//            JukeboxItem(URL: URL(string: "http://www.noiseaddicts.com/samples_1w72b820/2958.mp3")!)
//            ])
//        jukebox?.play()
    }
    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate) ->Bool {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            return false
        }
        
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as NSString as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate
        present(mediaUI, animated: true, completion: nil)
        return true
    }
    
    func startCameraFromViewController(viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = UIImagePickerControllerSourceType.camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension PlayVideoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        dismiss(animated: true, completion: {
            if mediaType == kUTTypeMovie as String {
                self.takeVideo(info: info)
            }
        })
    }
    
    func playVideo1(info: [String : Any]) {
        let moviePlayer = AVPlayer(url: info[UIImagePickerControllerMediaURL] as! URL)
        let moviePlayViewController = AVPlayerViewController()
        moviePlayViewController.player = moviePlayer

        self.present(moviePlayViewController, animated: true, completion: {
            moviePlayViewController.player!.play()
        })
    }
    
    func playVideo2(info: [String : Any]) {
        let player = AVPlayer(url: info[UIImagePickerControllerMediaURL] as! URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    func takeVideo(info: [String : Any]) {
        guard let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path else { return }
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
}

extension PlayVideoViewController: UINavigationControllerDelegate {
    
}
