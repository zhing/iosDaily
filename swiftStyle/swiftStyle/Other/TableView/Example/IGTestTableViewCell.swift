//
//  IGTestTableViewCell.swift
//  swiftStyle
//
//  Created by Qing Zhang on 1/13/17.
//  Copyright © 2017 Qing Zhang. All rights reserved.
//

import UIKit

class IGTestTableViewCell: IGTableViewBaseCell {
    
    var titleLabel :UILabel!
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        self.titleLabel = {
            let titleLabel = UILabel(frame: self.bounds)
            titleLabel.font = UIFont.systemFont(ofSize: 15)
            titleLabel.textColor = UIColor.black
            self.contentView.addSubview(titleLabel)
            return titleLabel
        }()
    }
    
    override func setObject(object: IGTableViewBaseItem) {
        titleLabel.text = object.itemTitle
    }
}
