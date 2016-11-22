//
//  BaseRefreshCtrl.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/22/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit

enum RefreshState {
    case idle
    case pulling
    case refreshing
    case noMoreData
}

typealias RefreshCallback = ()->Void

class BaseRefreshCtrl: UIView {
    var refreshCallback : RefreshCallback?
    var refreshState :RefreshState!
    var scrollViewOriginalInset :UIEdgeInsets!
    var scrollView :UIScrollView?
    
    override init(frame: CGRect) {
        refreshState = RefreshState.idle
        super.init(frame: frame)
        self.frameHeight = 54
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addObservers() {
        scrollView!.addObserver(self, forKeyPath: "contentOffset", options: ([NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]), context: nil)
        scrollView!.addObserver(self, forKeyPath: "contentSize", options: ([NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]), context: nil)
    }
    
    func removeObservers() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        superview?.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath! == "contentSize" {
            scrollViewContentSizeDidChange(change: change)
        }
        if isHidden {
            return
        }
        
        if keyPath! == "contentOffset" {
            scrollViewContentOffsetDidChange(change: change)
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeObservers()
        
        if newSuperview != nil && newSuperview!.isKind(of: UIScrollView.classForCoder()) {
            self.frameWidth = newSuperview!.frameWidth
            scrollView = newSuperview as! UIScrollView?
            scrollViewOriginalInset = scrollView!.contentInset
            addObservers()
        }
    }
    
    func beginRefreshing() {
        if refreshState != RefreshState.refreshing {
            refreshState = RefreshState.refreshing
            pullingPercentDidChanged(percent: 1.0)
        }
        
        UIView.animate(withDuration: 0.2, animations: {self.alpha = 1.0})
        refreshState = RefreshState.refreshing
        if let callback = refreshCallback {
            callback()
        }
    }
    
    func endRefreshing() {
        self.perform(#selector(setupRefreshStateIdle), with: nil, afterDelay: 0.05)
    }
    
    func setupRefreshStateIdle() {
        refreshState = RefreshState.idle
    }
    
    func isRefreshing() ->Bool {
        return RefreshState.refreshing == refreshState!
    }
    
    func pullingPercentDidChanged(percent:CGFloat) {
        
    }
    
    func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
    
    }
    
    func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
    }
}
