//
//  LoadMoreCtrl.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/23/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

class LoadMoreCtrl: UIControl {

    var activityView :UIActivityIndicatorView!
    var advanceTriggingValue :CGFloat
    
    var scrollView :UIScrollView!
    var statusLabel :UILabel!
    var loading :Bool!
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    init(scrollView: UIScrollView) {
        advanceTriggingValue = 0
        self.scrollView = scrollView
        super.init(frame: CGRect(x: 0, y: 0, width: scrollView.frameWidth, height: 50))
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = RGB(246, 246, 246)
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        
        statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = UIColor.black
        statusLabel.shadowColor = UIColor.white
        statusLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        statusLabel.backgroundColor = UIColor.clear
        statusLabel.text = "上拉可加载更多"
        self.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.addSubview(activityView)
        activityView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(20)
            make.trailing.equalTo(self.snp.centerX).offset(-50)
        }
        
        loading = false
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = keyPath, key == "contentOffset" {
            let offset = (change?[NSKeyValueChangeKey.newKey] as! CGPoint).y
            if scrollView.contentSize.height - offset - scrollView.frameHeight - 50 < advanceTriggingValue {
                beginLoadMore()
            }
        }
    }
    
    func beginLoadMore() {
        if !loading {
            loading = true
            statusLabel.text = "加载中..."
            activityView.startAnimating()
            self.sendActions(for: UIControlEvents.valueChanged)
        }
    }
    
    func endLoadMore() {
        if loading! {
            loading = false
            statusLabel.text = "上拉可加载更多"
            activityView.stopAnimating()
        }
    }
}
