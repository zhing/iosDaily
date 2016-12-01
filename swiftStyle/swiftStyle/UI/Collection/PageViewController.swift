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
//        pageControl.addTarget(self, action: #selector(changePage), for: UIControlEvents.valueChanged)
    }
    
    lazy var colors : [UIColor] = {
        [UIColor.red ,UIColor.blue, UIColor.green, UIColor.yellow, UIColor.red]
    }()
    
    func changePage(_ sender: AnyObject?) {
        let x = CGFloat(pageControl.currentPage) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func setupTimer() {
        timer = Timer(timeInterval: 1.0, repeats: true, block: { (timer) in
            let pageWidth = self.scrollView.bounds.width
            var xOffset = self.scrollView.contentOffset.x
            xOffset += pageWidth
            
            let index = Int(round(xOffset / pageWidth))
            if index == self.pageControl.numberOfPages {
                self.pageControl.currentPage = 0
            } else {
                self.pageControl.currentPage = index
            }
            
            if index > self.pageControl.numberOfPages {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                self.pageControl.currentPage = 1;
                self.scrollView.setContentOffset(CGPoint(x:pageWidth, y:0), animated:true);
            } else {
                self.scrollView.setContentOffset(CGPoint(x:xOffset, y:0), animated:true);
            }
        })
        
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
}

extension PageViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
