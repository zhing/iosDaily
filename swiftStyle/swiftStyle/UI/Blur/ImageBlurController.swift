//
//  ImageBlurController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/9/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

class ImageBlurController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var imageViewBkg:UIImageView!
    var imageViewFront:UIImageView!
    var slider:UISlider!
    var tableView:UITableView!
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentOffset")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Blur"
        self.view.backgroundColor = UIColor.white
        setupSubviews()
        
        tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }

    func setupSubviews() {
        let img:UIImage! = UIImage(named:"timg.jpeg")
        
        imageViewBkg = UIImageView()
        imageViewBkg.contentMode = UIViewContentMode.scaleToFill
        imageViewBkg.image = img.imageWithBlur()
        self.view.addSubview(imageViewBkg)
        imageViewBkg.snp.makeConstraints { (make)->Void in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        
        imageViewFront = UIImageView()
        imageViewFront.contentMode = UIViewContentMode.scaleToFill
        imageViewFront.image = img
        self.view.addSubview(imageViewFront)
        imageViewFront.snp.makeConstraints { (make)->Void in
            make.edges.equalTo(imageViewBkg)
        }
        
        slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.setValue(0, animated: true)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: UIControlEvents.valueChanged)
        self.view.addSubview(slider)
        slider.snp.makeConstraints { (make)->Void in
            make.bottom.equalTo(-100)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
        }
        
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
        
        slider.isHidden = true
    }
    
    func setFrontAlpha(_ alpha : CGFloat) {
        imageViewFront.alpha = 1.0 - alpha
    }
    
    func sliderValueChanged(sender: UISlider?) {
        setFrontAlpha(CGFloat((sender?.value)!)/100)
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
            var alpha: CGFloat!
            if yOffset > 0.0 && yOffset < 500 {
                alpha = yOffset / 500
            } else if yOffset <= 0.0 {
                alpha = 0
            } else {
                alpha = 1.0
            }
            
            setFrontAlpha(alpha)
        }
    }
}
