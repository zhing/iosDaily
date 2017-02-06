//
//  IGTestViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 1/13/17.
//  Copyright © 2017 Qing Zhang. All rights reserved.
//

import UIKit

class IGTestViewController: IGTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorInset = UIEdgeInsets.zero
        // Do any additional setup after loading the view.
    }

    override func createDataSource() {
        self.dataSource = IGTestTableViewDataSource()
    }

}
