//
//  IGTableViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 1/13/17.
//  Copyright © 2017 Qing Zhang. All rights reserved.
//

import UIKit

protocol IGTableViewControllerDelegate {
    func createDataSource()
}

class IGTableViewController: UIViewController, IGTableViewDelegate, IGTableViewControllerDelegate {

    var tableView :IGBaseTableView!
    var dataSource :IGTableViewDataSource?
    var tableViewStyle :UITableViewStyle
    
    init(style: UITableViewStyle) {
        self.tableViewStyle = style

        super.init(nibName: nil, bundle: nil)
        self.createDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createTableView()
    }

    func createDataSource() {
        assert(false, "this fuction should be override!")
    }
    
    func createTableView() {
        tableView = IGBaseTableView(frame: view.bounds, style: tableViewStyle)
        tableView.igDelegate = self
        tableView.igDataSource = self.dataSource
        view.addSubview(tableView)
    }
    
    func didSelectObject(object: AnyObject, indexPath: IndexPath) {
        
    }
    
    func headerViewForSectionObject(sectionObject: IGTableViewSectionObject, atSection: Int) -> UIView? {
        return nil
    }
}
