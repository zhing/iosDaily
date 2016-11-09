//
//  GPUImageBlurController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/9/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import GPUImage

class GPUImageBlurController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var tableView:UITableView!
    var img:UIImage!
    var stillImageSource:GPUImagePicture!
    var stillImageFilter:GPUImageGaussianBlurFilter!
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Blur"
        self.view.backgroundColor = UIColor.white
        setupSubviews()
        processBlur()
        
        tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func setupSubviews() {
        img = UIImage(named:"timg.jpeg")
        
        tableView = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make)->Void in
            make.top.equalTo(200)
            make.bottom.equalTo(0)
            make.width.equalTo(self.view)
        }
        
    }
    
    func processBlur() {
        stillImageSource = GPUImagePicture.init(image: img)
        stillImageFilter = GPUImageGaussianBlurFilter();
        
        let stillPreview :GPUImageView = GPUImageView.init(frame: self.view.bounds)
        self.view.insertSubview(stillPreview, at: 0)
        
        stillImageSource.addTarget(stillImageFilter)
        stillImageFilter.addTarget(stillPreview)
        stillImageFilter.useNextFrameForImageCapture()
        stillImageSource.processImage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.textLabel?.text = "weather \(indexPath.row)"
        return cell
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let yOffset = (change?[NSKeyValueChangeKey.newKey] as! CGPoint).y
            var blurLevel:CGFloat
            if yOffset > 0.0 && yOffset < 1000 {
                blurLevel = yOffset / 50
            } else if yOffset <= 0.0 {
                blurLevel = 0
            } else {
                blurLevel = 50
            }
            stillImageFilter.blurRadiusInPixels = blurLevel
            stillImageSource.processImage()
        }
    }
    
}
