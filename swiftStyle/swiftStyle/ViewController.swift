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
}

