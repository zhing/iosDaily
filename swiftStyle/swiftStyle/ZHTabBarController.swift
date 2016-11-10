//
//  ZHTabBarViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/7/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit

class ZHTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = UIColor.clear
        setupSubControllers()
        // Do any additional setup after loading the view.
    }
    
    func setupSubControllers() {
        let vc1 : ViewController? = ViewController()
        let vc2 : ViewController? = ViewController()
        let vc3 : ViewController? = ViewController()
        let vc4 : OtherViewController? = OtherViewController()
        
        let nav1 : ZHNavigationController = ZHNavigationController.init(rootViewController: vc1!)
        let nav2 : ZHNavigationController = ZHNavigationController.init(rootViewController: vc2!)
        let nav3 : ZHNavigationController = ZHNavigationController.init(rootViewController: vc3!)
        let nav4 : ZHNavigationController = ZHNavigationController.init(rootViewController: vc4!)
        
        nav1.tabBarItem = tabItemBy(title: "UI", imageName: "tab1.png")
        nav2.tabBarItem = tabItemBy(title: "Network", imageName: "tab2.png")
        nav3.tabBarItem = tabItemBy(title: "Storage", imageName: "tab3.png")
        nav4.tabBarItem = tabItemBy(title: "Other", imageName: "tab4.png")

        vc1?.title = "UI"
        vc2?.title = "Network"
        vc3?.title = "Storage"
        vc4?.title = "Other"
        
        self.viewControllers = [nav1, nav2, nav3, nav4]
        self.selectedIndex = 0
        self.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("select \(viewController.tabBarItem.title!) and tag is \(viewController.tabBarItem.tag)")
    }
    
    func tabItemBy(title: String, imageName: String) -> UITabBarItem {
        let img:UIImage? = UIImage.init(named: imageName)?.reSizeImage(size: CGSize.init(width: 20, height: 20))
        var imgSelected:UIImage? = img?.imageWithTintColor(tintColor: RGB(70, 183, 133))
        var imgNormal:UIImage? = img?.imageWithTintColor(tintColor: RGB(0x85, 0x8e, 0x99))
        
        imgSelected = imgSelected?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        imgNormal = imgNormal?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let item:UITabBarItem! = UITabBarItem.init(title: title, image: imgNormal, selectedImage: imgSelected)
        item.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -3)
        item.setTitleTextAttributes([NSForegroundColorAttributeName: RGB(70, 183, 133)], for: UIControlState.selected)
        return item;
    }
}
