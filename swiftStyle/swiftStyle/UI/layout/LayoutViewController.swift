//
//  LayoutViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/24/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

class LayoutViewController: UIViewController {
    var testLabel :UILabel!
    var testView :UITextView!
    var bkView :UIView!
    var imageView :UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "AutoLayout"
        setupViews()
    }
    
    func setupViews() {
        bkView = {
            let view = UIView()
            view .backgroundColor = UIColor.lightGray
            return view
        }()
        view.addSubview(bkView)
        bkView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        
        testLabel = {
            let label = UILabel()
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.gray
            label.numberOfLines = 0
            label.preferredMaxLayoutWidth = 100
            
            return label
        }()
        bkView.addSubview(testLabel)
        testLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(bkView)
        }
        
        testView = {
            let testView = UITextView()
            testView.font = UIFont.systemFont(ofSize: 17)
            testView.textColor = UIColor.white
            testView.backgroundColor = UIColor.gray
            return testView
        }()
        bkView.addSubview(testView)
        testView.snp.makeConstraints { (make) in
            make.top.equalTo(testLabel.snp.bottom).offset(10)
            make.centerX.equalTo(bkView)
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.bottom.equalTo(bkView)
        }
        
        testLabel.text = "天地玄黄 宇宙洪荒 日月盈昃 辰宿列张"
        testView.text = "天地玄黄 宇宙洪荒 日月盈昃 辰宿列张 寒来暑往 秋收冬藏 闰余成岁 律吕调阳"
        
        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.center
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(bkView.snp.bottom).offset(8)
            make.leading.equalTo(16)
            make.trailing.lessThanOrEqualTo(-16)
        }
        imageView.contentScaleFactor = UIScreen.main.scale;
        imageView.image = UIImage(named: "forkingdog.png")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
          * what is intrinsicContentSize(内容固有高度)、sizeThatFits(sizeToFit)、systemLayoutSizeFitting
         * CGRect paragraphRect = attributedText.boundingRectWithSize:CGSizeMake(300.f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
          */
        print("\(testLabel.intrinsicContentSize)")
        print("\(testLabel.frame)")
        print("\(testView.frame)")
        print("\(UILayoutFittingCompressedSize, UILayoutFittingExpandedSize)")
        print("\(bkView.systemLayoutSizeFitting(UILayoutFittingCompressedSize))")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let textSize = testView.sizeThatFits(CGSize(width: 300, height: 100))
        testView.snp.updateConstraints { (make) in
            make.width.equalTo(textSize.width)
            make.height.equalTo(textSize.height)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 只能改变vc的第一级subviews
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
