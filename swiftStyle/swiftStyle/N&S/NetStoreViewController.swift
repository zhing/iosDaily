//
//  NetworkViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/26/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit

class NetStoreViewController: UIViewController {
    var button01 :UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupSubviews()
    }
    
    func setupSubviews() {
        button01 = {
            let btn = UIButton(type: UIButtonType.custom)
            btn.setTitle("Network", for: UIControlState.normal)
            btn.titleLabel?.textAlignment = NSTextAlignment.center
            btn.backgroundColor = UIColor.lightGray
            btn.addTarget(self, action: #selector(NetStoreViewController.showNetworkViewController), for: UIControlEvents.touchUpInside)
            self.view.addSubview(btn)
            btn.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(100)
                make.leading.equalTo(20)
                make.top.equalTo(100)
            }
            return btn
        }()
    }
        
    func showNetworkViewController() {
        let controller = MainViewController.init()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
