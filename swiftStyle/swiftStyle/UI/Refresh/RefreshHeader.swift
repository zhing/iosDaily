//
//  RefreshHeader.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/22/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit

class RefreshHeader: BaseRefreshCtrl {
    var refreshPullTheshold  :CGFloat
    var endRefreshTime :Int64
    var pullDownContent :Bool
    
    class func refreshHeaderForCloures(callback: @escaping RefreshCallback) -> BaseRefreshCtrl?{
        return nil
    }
    
    override init(frame: CGRect) {
        refreshPullTheshold = ScreenHeight()
        endRefreshTime = 1
        pullDownContent = true
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        
        if refreshState == RefreshState.refreshing {
            return
        }
        
        scrollViewOriginalInset = scrollView!.contentInset
        let offsetY = scrollView!.contentOffset.y
        let happenOffsetY = -scrollViewOriginalInset.top
        if offsetY > happenOffsetY {
            return
        }
        
        let normal2pullingOffsetY = max(happenOffsetY - self.frameHeight, -refreshPullTheshold)
        let pullingPercent = (happenOffsetY - offsetY) /  self.frameHeight
        if scrollView!.isDragging {
            pullingPercentDidChanged(percent: pullingPercent)
            if refreshState == RefreshState.idle && offsetY < normal2pullingOffsetY {
                refreshState = RefreshState.pulling
            } else if refreshState == RefreshState.pulling && offsetY >= normal2pullingOffsetY {
                refreshState = RefreshState.idle
            }
        } else if refreshState == RefreshState.pulling {
            beginRefreshing()
        } else if pullingPercent < 1 {
            pullingPercentDidChanged(percent: pullingPercent)
        }
    }
    
    override var refreshState :RefreshState! {
        get {return super.refreshState}
        set {
            let oldState = super.refreshState
            if newValue == oldState && newValue != RefreshState.idle {
                return;
            }
            super.refreshState = newValue
            if refreshState == RefreshState.idle {
                if oldState != RefreshState.refreshing {
                    return
                }
                
                UIView.animate(withDuration: 0.6, animations: {
                    self.scrollView!.setInsetTop(self.scrollViewOriginalInset.top)
                }, completion: { (Bool) in
                    self.pullingPercentDidChanged(percent: 0.0)
                })
                
            } else if refreshState == RefreshState.refreshing {
                if pullDownContent {
                    let top = scrollViewOriginalInset!.top + self.bounds.size.height
                    let offset = scrollView!.contentOffset
                    scrollView!.setInsetTop(top)
                    scrollView!.contentOffset = offset
                }
            }
        }
    }
}
