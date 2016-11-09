//
//  MenuContainerView.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/9/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit

protocol containerClickDelegate: class {
    func onclick()
}

class MenuContainerView: UIView {
    
    var imageAddView :UIImageView!
    var imageMusicView :UIImageView!
    var imageLocationView :UIImageView!
    var imageCameraView :UIImageView!
    var imageTextView :UIImageView!
    var imageMoonView :UIImageView!
    var clickButton :UIButton!
    weak var clickDelegate :containerClickDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        imageMusicView = UIImageView()
        imageMusicView.image = UIImage(named: "music.png")?.reSizeImage(size: CGSize.init(width: 30, height: 30)).imageWithTintColor(tintColor: UIColor.orange)
        self.insertSubview(imageMusicView, at: 0)
        imageMusicView.snp.makeConstraints { (make)->Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        imageLocationView = UIImageView()
        imageLocationView.image = UIImage(named: "address.png")?.reSizeImage(size: CGSize.init(width: 30, height: 30)).imageWithTintColor(tintColor: UIColor.blue)
        self.insertSubview(imageLocationView, at: 1)
        imageLocationView.snp.makeConstraints { (make)->Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        imageCameraView = UIImageView()
        imageCameraView.image = UIImage(named: "camera.png")?.reSizeImage(size: CGSize.init(width: 30, height: 30)).imageWithTintColor(tintColor: UIColor.black)
        self.insertSubview(imageCameraView, at: 2)
        imageCameraView.snp.makeConstraints { (make)->Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        imageTextView = UIImageView()
        imageTextView.image = UIImage(named: "text.png")?.reSizeImage(size: CGSize.init(width: 30, height: 30)).imageWithTintColor(tintColor: UIColor.green)
        self.insertSubview(imageTextView, at: 3)
        imageTextView.snp.makeConstraints { (make)->Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        imageMoonView = UIImageView()
        imageMoonView.image = UIImage(named: "text.png")?.reSizeImage(size: CGSize.init(width: 30, height: 30)).imageWithTintColor(tintColor: UIColor.purple)
        self.insertSubview(imageMoonView, at: 4)
        imageMoonView.snp.makeConstraints { (make)->Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        imageAddView = UIImageView()
        imageAddView.backgroundColor = UIColor.white
        imageAddView.layer.cornerRadius = 20
        imageAddView.layer.masksToBounds = true
        imageAddView.image = UIImage(named: "add.png")?.reSizeImage(size: CGSize.init(width: 40, height: 40)).imageWithTintColor(tintColor: UIColor.red)
        self.addSubview(imageAddView)
        imageAddView.snp.makeConstraints { (make)->Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        clickButton = UIButton()
        clickButton.backgroundColor = UIColor.clear
        clickButton.addTarget(self, action: #selector(clickAction), for: UIControlEvents.touchUpInside)
        self.addSubview(clickButton)
        clickButton.snp.makeConstraints { (make)->Void in
            make.edges.equalTo(0)
        }
    }
    
    func clickAction() {
        clickDelegate?.onclick()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}
