//
//  PageViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 12/1/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

class PageViewController: UIViewController {
    
    var scrollView :UIScrollView!
    var pageControl :UIPageControl!
    var timer :Timer!
    
    deinit {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Page"
        view.backgroundColor = UIColor.white
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTimer()
    }
    
    func setupViews() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        scrollView = {
            let scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: ScreenWidth(), height: 300))
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
            view.addSubview(scrollView)
            return scrollView
        }()
        
        pageControl = {
            let pageControl = UIPageControl()
            pageControl.numberOfPages = colors.count - 1
            pageControl.currentPage = 0
            pageControl.tintColor = UIColor.red
            pageControl.pageIndicatorTintColor = UIColor.black
            pageControl.currentPageIndicatorTintColor = UIColor.green
            view.addSubview(pageControl)
            return pageControl
        }()
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(scrollView).offset(-30)
        }
        
        for index in 0..<colors.count {
            scrollView.isPagingEnabled = true
            let subView = UIView(frame: CGRect(origin: CGPoint(x: scrollView.bounds.width * CGFloat(index), y: 0), size: scrollView.bounds.size))
            subView.backgroundColor = colors[index]
            scrollView.addSubview(subView)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(pageControl.numberOfPages), height: scrollView.bounds.height)
    }
    
    lazy var colors : [UIColor] = {
        [UIColor.red ,UIColor.blue, UIColor.green, UIColor.yellow, UIColor.red]
    }()
    
    var pageWidth : CGFloat {
        return scrollView.bounds.width
    }
    
    var xOffset : CGFloat {
        get { return scrollView.contentOffset.x }
        set {
            scrollView.setContentOffset(CGPoint(x:newValue, y:0), animated:true);
        }
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changePage), userInfo: nil, repeats: true)
    }
    
    func changePage() {
        let offset = xOffset + pageWidth
        
        let index = Int(round(offset / pageWidth))
        if index == self.pageControl.numberOfPages {
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = index
        }
        
        if index > pageControl.numberOfPages {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
            pageControl.currentPage = 1
            xOffset = offset
        } else {
            xOffset = offset
        }
    }
}

extension PageViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.invalidate()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(xOffset / pageWidth)
        pageControl.currentPage = Int(pageNumber)
        xOffset = pageNumber * pageWidth
        
        setupTimer()
    }
}
