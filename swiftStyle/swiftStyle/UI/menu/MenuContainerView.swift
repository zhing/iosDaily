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
    let imgWidth :CGFloat = 20
    let imgHeight :CGFloat = 20
    let roundRadius :CGFloat = 17
    var isExtended :Bool = false
    
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
        imageMusicView.layer.cornerRadius = roundRadius
        imageMusicView.layer.masksToBounds = true
        imageMusicView.backgroundColor = UIColor.white
        imageMusicView.contentMode = UIViewContentMode.center
        imageMusicView.image = UIImage(named: "music.png")?.reSizeImage(size: CGSize.init(width: imgWidth, height: imgHeight)).imageWithTintColor(tintColor: UIColor.orange)
        self.insertSubview(imageMusicView, at: 0)
        
        imageLocationView = UIImageView()
        imageLocationView.layer.cornerRadius = roundRadius
        imageLocationView.layer.masksToBounds = true
        imageLocationView.backgroundColor = UIColor.white
        imageLocationView.contentMode = UIViewContentMode.center
        imageLocationView.image = UIImage(named: "address.png")?.reSizeImage(size: CGSize.init(width: imgWidth, height: imgHeight)).imageWithTintColor(tintColor: UIColor.blue)
        self.insertSubview(imageLocationView, at: 1)
        
        imageCameraView = UIImageView()
        imageCameraView.layer.cornerRadius = roundRadius
        imageCameraView.layer.masksToBounds = true
        imageCameraView.backgroundColor = UIColor.white
        imageCameraView.contentMode = UIViewContentMode.center
        imageCameraView.image = UIImage(named: "camera.png")?.reSizeImage(size: CGSize.init(width: imgWidth, height: imgHeight)).imageWithTintColor(tintColor: UIColor.black)
        self.insertSubview(imageCameraView, at: 2)
        
        imageTextView = UIImageView()
        imageTextView.layer.cornerRadius = roundRadius
        imageTextView.layer.masksToBounds = true
        imageTextView.backgroundColor = UIColor.white
        imageTextView.contentMode = UIViewContentMode.center
        imageTextView.image = UIImage(named: "text.png")?.reSizeImage(size: CGSize.init(width: imgWidth, height: imgHeight)).imageWithTintColor(tintColor: UIColor.green)
        self.insertSubview(imageTextView, at: 3)
        
        imageMoonView = UIImageView()
        imageMoonView.layer.cornerRadius = roundRadius
        imageMoonView.layer.masksToBounds = true
        imageMoonView.backgroundColor = UIColor.white
        imageMoonView.contentMode = UIViewContentMode.center
        imageMoonView.image = UIImage(named: "moon.png")?.reSizeImage(size: CGSize.init(width: imgWidth, height: imgHeight)).imageWithTintColor(tintColor: UIColor.purple)
        self.insertSubview(imageMoonView, at: 4)
        
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
        
        updateSubviewConstraints()
    }
    
    func clickAction() {
        clickDelegate?.onclick()
    }
    
    func updateSubviewConstraints() {
        if isExtended {
            imageMusicView.snp.remakeConstraints{ make in
                make.centerX.equalTo(self).offset(-100 * cos(M_PI/6))
                make.centerY.equalTo(self).offset(-100 * sin(M_PI/6))
                make.size.equalTo(CGSize.init(width: roundRadius*2, height: roundRadius*2))
            }
            imageLocationView.snp.remakeConstraints { (make)->Void in
                make.centerX.equalTo(self).offset(-100 * cos(M_PI/3))
                make.centerY.equalTo(self).offset(-100 * sin(M_PI/3))
                make.size.equalTo(CGSize.init(width: roundRadius*2, height: roundRadius*2))
            }
            imageCameraView.snp.remakeConstraints { (make)->Void in
                make.centerX.equalTo(self).offset(-100 * cos(M_PI/2))
                make.centerY.equalTo(self).offset(-100 * sin(M_PI/2))
                make.size.equalTo(CGSize.init(width: roundRadius*2, height: roundRadius*2))
            }
            imageTextView.snp.remakeConstraints { (make)->Void in
                make.centerX.equalTo(self).offset(-100 * cos(M_PI*2/3))
                make.centerY.equalTo(self).offset(-100 * sin(M_PI*2/3))
                make.size.equalTo(CGSize.init(width: roundRadius*2, height: roundRadius*2))
            }
            imageMoonView.snp.remakeConstraints { (make)->Void in
                make.centerX.equalTo(self).offset(-100 * cos(M_PI*5/6))
                make.centerY.equalTo(self).offset(-100 * sin(M_PI*5/6))
                make.size.equalTo(CGSize.init(width: roundRadius*2, height: roundRadius*2))
            }
        } else {
            imageMusicView.snp.remakeConstraints { (make)->Void in
                make.center.equalTo(self)
                make.size.equalTo(CGSize.init(width: roundRadius*2, height: roundRadius*2))
            }
            imageLocationView.snp.remakeConstraints { (make)->Void in
                make.center.equalTo(self)
                make.size.equalTo(CGSize.init(width: roundRadius*2, height: roundRadius*2))
            }
            imageCameraView.snp.remakeConstraints { (make)->Void in
                make.center.equalTo(self)
                make.size.equalTo(CGSize.init(width: roundRadius*2, height: roundRadius*2))
            }
            imageTextView.snp.remakeConstraints { (make)->Void in
                make.center.equalTo(self)
                make.size.equalTo(CGSize.init(width: roundRadius*2, height: roundRadius*2))
            }
            imageMoonView.snp.remakeConstraints { (make)->Void in
                make.center.equalTo(self)
                make.size.equalTo(CGSize.init(width: roundRadius*2, height: roundRadius*2))
            }
        }
    }
    
    func updateTransform() {
        if isExtended {
//            imageMusicView.transform = imageMusicView.transform.rotated(by: -CGFloat(M_PI)*3)
//            imageLocationView.transform=imageLocationView.transform.rotated(by: -CGFloat(M_PI)*3)
//            imageCameraView.transform=imageCameraView.transform.rotated(by: -CGFloat(M_PI))
//            imageTextView.transform=imageTextView.transform.rotated(by: -CGFloat(M_PI)*3)
//            imageMoonView.transform=imageMoonView.transform.rotated(by: -CGFloat(M_PI)*3)
            
            imageAddView.transform = imageAddView.transform.rotated(by: -CGFloat(M_PI)*3/4)
        } else {
//            imageMusicView.transform=imageMusicView.transform.rotated(by: CGFloat(M_PI)*3)
//            imageLocationView.transform=imageLocationView.transform.rotated(by: CGFloat(M_PI)*3)
//            imageCameraView.transform=imageCameraView.transform.rotated(by: CGFloat(M_PI))
//            imageTextView.transform=imageTextView.transform.rotated(by: CGFloat(M_PI)*3)
//            imageMoonView.transform=imageMoonView.transform.rotated(by: CGFloat(M_PI)*3)
            
            imageAddView.transform = imageAddView.transform.rotated(by: CGFloat(M_PI)*3/4)
        }
    }
    
    func forceLayout() {
        updateSubviewConstraints()
        UIView.animate(withDuration: 0.25, animations: {
            self.updateTransform()
            self.layoutIfNeeded()
        })
    }
}
