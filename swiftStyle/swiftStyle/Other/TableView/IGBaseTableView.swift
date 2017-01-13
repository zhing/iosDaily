//
//  IGBaseTableView.swift
//  swiftStyle
//
//  Created by Qing Zhang on 1/12/17.
//  Copyright © 2017 Qing Zhang. All rights reserved.
//

import UIKit

protocol IGTableViewDelegate : UITableViewDelegate {
    func didSelectObject(object: AnyObject, indexPath: IndexPath)
    func headerViewForSectionObject(sectionObject: IGTableViewSectionObject, atSection:Int) -> UIView?
}

class IGBaseTableView: UITableView, UITableViewDelegate {
    var igDataSource : IGTableViewDataSourceProtocol? {
        get { return self.igDataSource }
        set {
            self.igDataSource = newValue
            self.dataSource = igDataSource
        }
    }
    var igDelegate : IGTableViewDelegate?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.separatorColor = UIColor.clear
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = false
        self.sectionHeaderHeight = 0
        self.sectionFooterHeight = 0
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataSource = tableView.dataSource as! IGTableViewDataSource
        if let object = dataSource.objectForRow(tableView: tableView, indexPath: indexPath) {
            let cls = dataSource.cellClassForObject(tableView: tableView, object: object)
            object.cellHeight = cls.rowHeightForObject(tableView: tableView, object: object)
            return object.cellHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = self.igDelegate?.responds(to: Selector(("didSelectObject:atIndexPath:"))) {
            let dataSource = tableView.dataSource as! IGTableViewDataSource
            let obj = dataSource.objectForRow(tableView: tableView, indexPath: indexPath)
            self.igDelegate?.didSelectObject(object: obj!, indexPath: indexPath)
        } else if let _ = self.igDelegate?.responds(to: #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))) {
            self.igDelegate?.tableView!(tableView, didSelectRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let _ = self.igDelegate?.responds(to: Selector(("headerViewForSectionObject:atSection:"))) {
            let dataSource = tableView.dataSource as! IGTableViewDataSource
            let sectionObject = dataSource.sections[section]
            return self.igDelegate?.headerViewForSectionObject(sectionObject: sectionObject, atSection: section)
        } else if let _ = self.igDelegate?.responds(to: #selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:))) {
            return self.igDelegate?.tableView!(tableView, viewForHeaderInSection: section)
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.igDelegate?.tableView!(tableView, willDisplay: cell, forRowAt: indexPath)
    }
}
