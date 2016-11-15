//
//  OtherViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/10/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

class OtherViewController: UIViewController {

    var button01 :UIButton!
    var button02 :UIButton!
    var button03 :UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupSubviews()
    }

    func setupSubviews() {
        button01 = UIButton.init(type: UIButtonType.custom)
        button01.setTitle("AMap", for: UIControlState.normal)
        button01.titleLabel?.textAlignment = NSTextAlignment.center
        button01.backgroundColor = UIColor.lightGray
        button01.addTarget(self, action: #selector(showAMapViewController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button01)
        button01.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.leading.equalTo(20)
            make.top.equalTo(100)
        }
        
        button02 = UIButton.init(type: UIButtonType.custom)
        button02.setTitle("Video", for: UIControlState.normal)
        button02.titleLabel?.textAlignment = NSTextAlignment.center
        button02.backgroundColor = UIColor.lightGray
        button02.addTarget(self, action: #selector(showVideoViewController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button02)
        button02.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.leading.equalTo(20)
            make.top.equalTo(button01.snp.bottom).offset(20)
        }
        
        button03 = UIButton.init(type: UIButtonType.custom)
        button03.setTitle("Audio", for: UIControlState.normal)
        button03.titleLabel?.textAlignment = NSTextAlignment.center
        button03.backgroundColor = UIColor.lightGray
        button03.addTarget(self, action: #selector(showAudioViewController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button03)
        button03.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.leading.equalTo(20)
            make.top.equalTo(button02.snp.bottom).offset(20)
        }
    }
    
    func showAMapViewController(sender : AnyObject?) {
        let controller = MainViewController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showVideoViewController(sender : AnyObject?) {
        let controller = PlayVideoViewController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showAudioViewController(sender : AnyObject?) {
        let controller = AudioPlayerViewController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
