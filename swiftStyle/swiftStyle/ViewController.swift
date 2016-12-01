//
//  ViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 10/26/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var button01 : UIButton!
    var button02 : UIButton!
    var button03 : UIButton!
    var button04 : UIButton!
    var button05 : UIButton!
    var button06 : UIButton!
    var button07 : UIButton!
    var button08 : UIButton!
    var button09 : UIButton!
    
    var button11 : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        setupSubViews()
    }

    func setupSubViews() {
        button01 = UIButton.init(type: UIButtonType.custom)
        button01.setTitle("image", for: UIControlState.normal)
        button01.titleLabel?.textAlignment = NSTextAlignment.center
        button01.backgroundColor = UIColor.lightGray
        button01.addTarget(self, action: #selector(ViewController.showGPUImageController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button01)
        button01.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.leading.equalTo(20)
            make.top.equalTo(100)
        }
        
        button02 = UIButton.init(type: UIButtonType.custom)
        button02.setTitle("Blur", for: UIControlState.normal)
        button02.backgroundColor = UIColor.lightGray
        button02.addTarget(self, action: #selector(ViewController.showImageBlurController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button02)
        button02.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(button01)
            make.leading.equalTo(button01)
            make.top.equalTo(button01.snp.bottom).offset(20)
        }
        
        button03 = UIButton.init(type: UIButtonType.custom)
        button03.setTitle("Beauty", for: UIControlState.normal)
        button03.backgroundColor = UIColor.lightGray
        button03.addTarget(self, action: #selector(ViewController.showImageBeautyController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button03)
        button03.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(button02)
            make.leading.equalTo(button02)
            make.top.equalTo(button02.snp.bottom).offset(20)
        }
        
        button04 = UIButton.init(type: UIButtonType.custom)
        button04.setTitle("GPUBlur", for: UIControlState.normal)
        button04.backgroundColor = UIColor.lightGray
        button04.addTarget(self, action: #selector(ViewController.showGPUImageBlurController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button04)
        button04.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(button03)
            make.leading.equalTo(button03)
            make.top.equalTo(button03.snp.bottom).offset(20)
        }
        
        button05 = UIButton.init(type: UIButtonType.custom)
        button05.setTitle("Menu", for: UIControlState.normal)
        button05.backgroundColor = UIColor.lightGray
        button05.addTarget(self, action: #selector(ViewController.showMenuController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button05)
        button05.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(button04)
            make.leading.equalTo(button04)
            make.top.equalTo(button04.snp.bottom).offset(20)
        }
        
        button06 = UIButton.init(type: UIButtonType.custom)
        button06.setTitle("Refresh", for: UIControlState.normal)
        button06.backgroundColor = UIColor.lightGray
        button06.addTarget(self, action: #selector(showRefreshController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button06)
        button06.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(button05)
            make.leading.equalTo(button05)
            make.top.equalTo(button05.snp.bottom).offset(20)
        }
        
        button07 = UIButton.init(type: UIButtonType.custom)
        button07.setTitle("AutoLayout", for: UIControlState.normal)
        button07.backgroundColor = UIColor.lightGray
        button07.addTarget(self, action: #selector(showAutoLayoutController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button07)
        button07.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(button06)
            make.leading.equalTo(button06)
            make.top.equalTo(button06.snp.bottom).offset(20)
        }
        
        button08 = UIButton.init(type: UIButtonType.custom)
        button08.setTitle("Feed", for: UIControlState.normal)
        button08.backgroundColor = UIColor.lightGray
        button08.addTarget(self, action: #selector(showFeedController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button08)
        button08.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(button07)
            make.leading.equalTo(button07)
            make.top.equalTo(button07.snp.bottom).offset(20)
        }
        
        button09 = UIButton.init(type: UIButtonType.custom)
        button09.setTitle("Loop", for: UIControlState.normal)
        button09.backgroundColor = UIColor.lightGray
        button09.addTarget(self, action: #selector(showLoopController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button09)
        button09.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(button08)
            make.leading.equalTo(button08)
            make.top.equalTo(button08.snp.bottom).offset(20)
        }
        
        button11 = UIButton.init(type: UIButtonType.custom)
        button11.setTitle("Page", for: UIControlState.normal)
        button11.backgroundColor = UIColor.lightGray
        button11.addTarget(self, action: #selector(showPageController), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button11)
        button11.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(button01)
            make.top.equalTo(button01)
            make.centerX.equalTo(view)
        }
    }
    
    func showGPUImageController() {
        let controller = GPUViewController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showImageBlurController() {
        let controller = ImageBlurController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showImageBeautyController() {
        let controller = BeautyController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showGPUImageBlurController() {
        let controller = GPUImageBlurController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showMenuController() {
        let controller = MenuController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showRefreshController() {
        let controller = TableRefreshViewController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showAutoLayoutController() {
        let controller = LayoutViewController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showFeedController() {
        let controller = FeedViewController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showLoopController() {
        let controller = LoopViewController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showPageController() {
        let controller = PageViewController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

