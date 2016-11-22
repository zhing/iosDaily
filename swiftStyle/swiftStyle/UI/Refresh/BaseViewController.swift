//
//  BaseViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/22/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var refreshHeader :BaseRefreshCtrl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func addPullToRefreshForScrollView(_ scrollView :UIScrollView, refreshSel refreshSelector: Selector) {
        refreshHeader = DefaultRefreshCtrl.refreshHeaderForCloures(callback: {
            self.perform(refreshSelector)
            })
        
        scrollView.insertSubview(refreshHeader!, at: 0)
        scrollView.bringSubview(toFront: refreshHeader!)
    }
    
    func removePullToRefreshForScrollView(_ scrollView: UIScrollView) {
        refreshHeader = nil
    }
    
    func endRefreshing(_ scrollView :UIScrollView) {
        refreshHeader!.endRefreshing()
    }
}
