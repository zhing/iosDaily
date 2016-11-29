//
//  FeedCell.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/24/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

class FeedCell: UITableViewCell {
    var titleLabel :UILabel!
    var contentLabel :UILabel!
    var postView: UIImageView!
    var nameLabel :UILabel!
    var timeLabel :UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupViews() {
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.purple
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(16)
            make.trailing.lessThanOrEqualTo(0)
        }
        
        contentLabel = UILabel()
        contentLabel.textColor = UIColor.gray
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        contentLabel.preferredMaxLayoutWidth = 315
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(16)
            make.trailing.lessThanOrEqualTo(0)
        }
        
        postView = UIImageView()
        postView.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubview(postView)
        postView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.equalTo(16)
            make.trailing.lessThanOrEqualTo(-16)
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.textColor = UIColor.lightGray
        nameLabel.textAlignment = NSTextAlignment.left
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.top.equalTo(postView.snp.bottom).offset(8)
        }
        
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = UIColor.lightGray
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalTo(-30)
            make.bottom.equalTo(0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postView.image = nil
    }
    
    var feedEntity : FeedEntity {
        get { return self.feedEntity }
        set {
            titleLabel.text = newValue.title
            contentLabel.text = newValue.content
            if let imgName = newValue.imageName,
                let img = UIImage(named: "\(imgName).png") {
                postView.image = img.resizeImageByScale()
            }
            nameLabel.text = newValue.username
            timeLabel.text = newValue.time
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
