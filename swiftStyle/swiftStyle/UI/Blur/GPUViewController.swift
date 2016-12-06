//
//  GPUViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/8/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit
import GPUImage

class GPUViewController: UIViewController {
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var img: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GPU"
        self.view.backgroundColor = UIColor.white
        
        setupSubViews()
    }

    func setupSubViews() {
        img = UIImage(named: "photo")
        
        imageView1 = UIImageView.init(image: img)
        self.view.addSubview(imageView1)
        imageView1.snp.makeConstraints { (make)->Void in
            make.top.equalTo(100)
            make.leading.equalTo(20)
            make.width.height.equalTo(100)
        }
        
        let filteredImage = processingStillImage()
        imageView2 = UIImageView.init(image: filteredImage)
        self.view.addSubview(imageView2)
        imageView2.snp.makeConstraints { (make)->Void in
            make.top.equalTo(imageView1)
            make.leading.equalTo(imageView1.snp.trailing).offset(20)
            make.width.height.equalTo(100)
        }
    }
    
    func processingStillImage() -> UIImage{
        let stillImageSource:GPUImagePicture = GPUImagePicture.init(image: img)
        let stillImageFilter:GPUImageGaussianBlurFilter = GPUImageGaussianBlurFilter();
        
        stillImageFilter.blurRadiusInPixels = 30.0
        stillImageSource.addTarget(stillImageFilter)
        stillImageFilter.useNextFrameForImageCapture()
        stillImageSource.processImage()
        
        let quickFilteredImage = stillImageFilter.imageFromCurrentFramebuffer()
        return quickFilteredImage!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
