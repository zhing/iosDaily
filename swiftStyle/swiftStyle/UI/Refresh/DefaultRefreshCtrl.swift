//
//  DefaultRefreshCtrl.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/22/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

class DefaultRefreshCtrl: RefreshHeader {
    var loadingView :UIActivityIndicatorView!
    var tipText :UILabel!
    var headerHeight :CGFloat?
    var tipLabelHidden :Bool
    
    override class func refreshHeaderForCloures(callback: @escaping RefreshCallback) -> BaseRefreshCtrl?{
        let header:DefaultRefreshCtrl? = DefaultRefreshCtrl(frame: CGRect.zero)
        header!.refreshCallback = callback
        return header
    }
    
    override init(frame: CGRect) {
        tipLabelHidden = false
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.addSubview(loadingView)
        loadingView.startAnimating()
        loadingView.isHidden = true
        
        tipText = UILabel()
        tipText.backgroundColor = UIColor.clear
        tipText.font = UIFont.systemFont(ofSize: 14)
        tipText.textColor = RGB(0x92, 0x95, 0x9e)
        tipText.text = "下拉刷新"
        self.addSubview(tipText)
        
        loadingView.snp.makeConstraints { (make) in
            make.height.equalTo(self.frameHeight)
            make.width.equalTo(60)
            make.top.equalTo(0)
            make.centerX.equalTo(self).offset(-50)
        }
        
        tipText.snp.makeConstraints { (make) in
            make.centerY.equalTo(loadingView)
            make.height.equalTo(20)
            make.centerX.equalTo(self).offset(30)
            make.width.equalTo(100)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frameY = -self.frameHeight
    }
    
    override func pullingPercentDidChanged(percent: CGFloat) {
        if percent > 0 {
            if scrollView!.isDragging {
                loadingView.alpha = 1.0
                tipText.alpha = 1.0
                loadingView.isHidden = false
                tipText.isHidden = false
            } else {
                loadingView.alpha = 0.0
                tipText.alpha = 0.0
            }
        } else {
            if refreshState == RefreshState.idle {
                UIView.animate(withDuration: 0.1, animations: {
                    self.loadingView.alpha = 0.0
                    self.tipText.alpha = 0.0
                }, completion: { (Bool) in
                    if !self.tipLabelHidden {
                        self.tipText.text = "下拉刷新"
                    }
                })
            }
        }
    }
    
    override var refreshState: RefreshState! {
        get {return super.refreshState}
        set {
            super.refreshState = newValue
            
            if refreshState != RefreshState.idle {
                loadingView.alpha = 1.0
                loadingView.isHidden = false
                tipText.alpha = 1.0
                tipText.isHidden = false
            }
            
            if tipLabelHidden {
                tipText.text = ""
            } else if refreshState == RefreshState.idle {
                tipText.text = "刷新完成"
            } else if refreshState == RefreshState.pulling {
                tipText.text = "松开立即刷新"
            } else if refreshState == RefreshState.refreshing {
                tipText.text = "正在刷新"
            } else {
                tipText.text = "下拉刷新"
            }
        }
    }
}
