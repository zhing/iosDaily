//
//  LoopCollectionViewCell.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/29/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

class LoopCollectionViewCell: UICollectionViewCell {
    var imageView :UIImageView!
    var titleLabel :UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.backgroundColor = UIColor.gray
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = true
        
        imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.leading.equalTo(8)
            make.width.height.equalTo(104)
        }
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalTo(contentView)
        }
    }
}
