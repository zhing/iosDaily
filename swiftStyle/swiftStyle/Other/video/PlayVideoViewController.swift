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
import BMPlayer

class PlayVideoViewController: UIViewController {
    var button01 :UIButton!
    var player :BMPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "palyVideo"
        self.view.backgroundColor = UIColor.white
        setupSubViews()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "pick", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickLocalVedio))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initResource()
    }
    
    func setupSubViews() {
        player = BMPlayer()
        view.addSubview(player!)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(64)
            make.left.right.equalTo(self.view)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        
        player.backBlock = {[unowned self] in
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        BMPlayerConf.shouldAutoPlay = false
    }
    
    func initResource() {
        let resource0 = BMPlayerItemDefinitionItem(url: URL(string: "http://baobab.wdjcdn.com/14570071502774.mp4")!, definitionName: "HD")
        let resource1 = BMPlayerItemDefinitionItem(url: URL(string: "http://baobab.wdjcdn.com/1457007294968_5824_854x480.mp4")!, definitionName: "SD")
        
        let item = BMPlayerItem(title: "周末号外丨川普版权力的游戏",
                                resource: [resource0, resource1],
                                cover: "http://img.wdjimg.com/image/video/acdba01e52efe8082d7c33556cf61549_0_0.jpeg")
        player.playWithPlayerItem(item)
    }
    
    func pickLocalVedio() {
        _ = startMediaBrowserFromViewController(viewController: self, usingDelegate: self)
        //        _ = startCameraFromViewController(viewController: self, withDelegate: self)
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
                self.playVideo2(info: info)
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
    
    func playVideoByBMPlayer(info: [String : Any]) {
//        let resource = BMPlayerItemDefinitionItem(url: info[UIImagePickerControllerMediaURL] as! URL, definitionName: "SD")
//        let playItem = BMPlayerItem.init(title: "video", resource: [resource])
        player.removeFromSuperview()
        player = nil
        setupSubViews()
        player.playWithURL(info[UIImagePickerControllerMediaURL] as! URL)
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
