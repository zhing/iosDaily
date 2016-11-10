//
//  MenuController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/9/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

class MenuController: UIViewController, containerClickDelegate{
    var window :UIWindow!
    var bottomView :UIView!
    var containerView: MenuContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "menu"
        self.view.backgroundColor = UIColor.white
        setupSubviews()
        containerView.clickDelegate = self
    }
    
    func setupSubviews() {
        
        bottomView = UIView()
        bottomView.backgroundColor = RGB(249, 249, 249)
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make)->Void in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(49)
        }
        _ = bottomView.addHorzLine(start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: ScreenWidth(), y: 0), color: UIColor.black.withAlphaComponent(0.3), borderWith: 0.5)
        
        containerView = MenuContainerView.init(frame: CGRect.init(x: 0, y: 0, width: 49, height: 49))
        containerView.backgroundColor = UIColor.clear
        bottomView.addSubview(containerView)
        containerView.snp.makeConstraints { (make)->Void in
            make.size.equalTo(CGSize.init(width: 49, height: 49))
            make.center.equalTo(bottomView)
        }
        
        containerView.isUserInteractionEnabled=true
    }
    
    func onclick() {
        if window == nil || window.isHidden {
            showBlurWindow(sender: nil)
        }else {
            hideBlurWindow(sender: nil)
        }
    }
    
    func showBlurWindow(sender: AnyObject?) {
        if window == nil {
            window = UIWindow.init(frame: self.view.bounds)
            window.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
            window.windowLevel = UIWindowLevelAlert
            window.makeKeyAndVisible()
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(hideBlurWindow))
            window.addGestureRecognizer(tapGesture)
        }
        window.isHidden = false
        
        containerView.removeFromSuperview()
        window.addSubview(containerView)
        containerView.snp.makeConstraints { (make)->Void in
            make.size.equalTo(CGSize.init(width: 49, height: 49))
            make.bottom.equalTo(0)
            make.centerX.equalTo(window)
        }
        
        containerView.isExtended = true
        containerView.forceLayout()
    }
    
    func hideBlurWindow(sender: AnyObject?) {
        window.isHidden = true
        
        containerView.removeFromSuperview()
        bottomView.addSubview(containerView)
        containerView.snp.makeConstraints { (make)->Void in
            make.size.equalTo(CGSize.init(width: 49, height: 49))
            make.center.equalTo(bottomView)
        }
        
        containerView.isExtended = false
        containerView.forceLayout()
    }
}
