//
//  IGTableViewDataSource.swift
//  swiftStyle
//
//  Created by Qing Zhang on 1/12/17.
//  Copyright © 2017 Qing Zhang. All rights reserved.
//

import UIKit

protocol IGTableViewDataSourceProtocol: UITableViewDataSource {
    func objectForRow(tableView: UITableView, indexPath: IndexPath) -> IGTableViewBaseItem?
    func cellClassForObject(tableView: UITableView, object: IGTableViewBaseItem) ->IGTableViewBaseCell.Type
}

class IGTableViewDataSource: NSObject, IGTableViewDataSourceProtocol {

    lazy var sections :Array<IGTableViewSectionObject> = []
    
    func clearAllItems() {
        sections.removeAll()
    }
    
    //MARK:- IGTableViewDataSourceProtocol
    func objectForRow(tableView: UITableView, indexPath: IndexPath) -> IGTableViewBaseItem? {
        if sections.count > indexPath.section {
            let sectionObject = sections[indexPath.section]
            if sectionObject.items.count > indexPath.row {
                return sectionObject.items[indexPath.row]
            }
        }
        
        return nil
    }
    
    func cellClassForObject(tableView: UITableView, object: IGTableViewBaseItem) -> IGTableViewBaseCell.Type {
        return IGTableViewBaseCell.self
    }
    
    //MARK:- UITableViewDataSource required
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            return sections[section].items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = objectForRow(tableView: tableView, indexPath: indexPath)
        let cellClass = cellClassForObject(tableView: tableView, object: object!)
        let cellClassName = NSStringFromClass(cellClass)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellClassName) as! IGTableViewBaseCell?
        if cell == nil {
            cell = cellClass.init(style: UITableViewCellStyle.default, reuseIdentifier:nil)
        }
        cell?.setObject(object: object!)
        return cell!
    }
    
    //MARK:- UITableViewDataSource optional
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < sections.count {
            return sections[section].headerTitle
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section < sections.count {
            return sections[section].footerTitle
        }
        return nil
    }
}
