//
//  IGTestTableViewDataSource.swift
//  swiftStyle
//
//  Created by Qing Zhang on 1/13/17.
//  Copyright © 2017 Qing Zhang. All rights reserved.
//

import UIKit

class IGTestTableViewDataSource: IGTableViewDataSource {
    
    override init() {
        super.init()
        self.createData()
    }
    
    func createData() {
        let sectionObject = IGTableViewSectionObject(itemArray: [
            IGTableViewBaseItem(title: "第一条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第二条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第三条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第四条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第五条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第六条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第七条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第八条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第九条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第十条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第十一条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第十二条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第十三条消息", subTitle: nil, image: nil),
            IGTableViewBaseItem(title: "第十四条消息", subTitle: nil, image: nil)
            ])
        
        self.sections = [sectionObject]
    }
    
    override func cellClassForObject(tableView: UITableView, object: IGTableViewBaseItem) -> IGTableViewBaseCell.Type {
        return IGTestTableViewCell.self
    }
}
