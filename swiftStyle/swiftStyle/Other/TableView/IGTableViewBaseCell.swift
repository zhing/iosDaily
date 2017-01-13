//
//  IGTableViewBaseCell.swift
//  swiftStyle
//
//  Created by Qing Zhang on 1/12/17.
//  Copyright © 2017 Qing Zhang. All rights reserved.
//

import UIKit

class IGTableViewBaseCell: UITableViewCell {
    
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func rowHeightForObject(tableView: UITableView, object: IGTableViewBaseItem) -> CGFloat {
        return 44.0
    }

    func setObject(object: IGTableViewBaseItem) {
        assert(false, "this fuction should be override!")
    }
}
