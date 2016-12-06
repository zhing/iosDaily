//
//  ZHTableView.swift
//  swiftStyle
//
//  Created by Qing Zhang on 12/6/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit

class IGTableView: UITableView {

    private var blankView :UIView?
    private var sectionOfBlankView :Int!
    private var blankViewScrollable :Bool = false
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.tableFooterView = UIView(frame:CGRect(x: 0, y: 0, width: self.bounds.width, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reloadData() {
        super.reloadData()
        layoutBlankView()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let _ = blankView?.superview {
            if !blankViewScrollable {
                blankView?.frame = blankViewFrame
            }
        }
    }
    
    internal func setBlankView(_ view : UIView?) {
        setBlankView(view, forSection: 0, scrollable: false)
    }
    
    internal func setBlankView(_ view : UIView?, forSection section: Int) {
        setBlankView(view, forSection: section, scrollable: false)
    }
    
    internal func setBlankView(_ view : UIView?, forSection section: Int, scrollable: Bool) {
        blankView = view
        sectionOfBlankView = section
        blankViewScrollable = scrollable
        
        layoutBlankView()
    }
    
    private func layoutBlankView(){
        if shouldShowBlankView {
            showBlankView()
        } else {
            hideBlankView()
        }
    }
    
    private var shouldShowBlankView : Bool {
        if let _ = blankView,
            let section = sectionOfBlankView {
                return section >= numberOfSections || numberOfRows(inSection: section) == 0
        }
        
        return false
    }
    
    private func showBlankView() {
        if let blank = blankView {
            if blankViewScrollable {
                tableFooterView = blank
            } else {
                isScrollEnabled = false
                blank.frame = blankViewFrame
                superview?.addSubview(blank)
            }
        }
    }
    
    private func hideBlankView() {
        if blankView?.superview != nil {
            if blankViewScrollable {
                tableFooterView = nil
            } else {
                isScrollEnabled = true
                blankView?.removeFromSuperview()
            }
        }
    }
    
    private var blankViewFrame : CGRect {
        var originFrame = frame
        originFrame.origin.y += blankViewTopMargin
        originFrame.size.height -= blankViewTopMargin
        return originFrame
    }
    
    private var blankViewTopMargin : CGFloat{
        var top = contentInset.top
        if let header = tableHeaderView {
            top += header.frameHeight
        }
        
        for section in 0..<numberOfSections {
            let sectionFrame = rect(forSection: section)
            top += sectionFrame.height
        }
        if let footer = tableFooterView {
            top += footer.frameHeight
        }
        
        return top
    }
}
