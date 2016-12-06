//
//  EmptyDataView.swift
//  swiftStyle
//
//  Created by Qing Zhang on 12/6/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SnapKit

protocol EmptyDataViewActionDelegate: class {
    func didClickEmptyButton()
}

class EmptyDataView: UIView {

    var emptyImageView  :UIImageView!
    var emptyTitleLabel :UILabel!
    var emptyLabel      :UILabel!
    var emptyButton     :UIButton!
    var emptyDelegate   :EmptyDataViewActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        emptyImageView = UIImageView()
        addSubview(emptyImageView)
        
        emptyTitleLabel = {
            let label = UILabel()
            label.textColor = RGB(45, 45, 45)
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = NSTextAlignment.center
            label.isHidden = true
            addSubview(label)
            return label
        }()
        
        emptyLabel = {
            let label = UILabel()
            label.textColor = RGB(0x92, 0x95, 0x9e)
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = NSTextAlignment.center
            label.numberOfLines = 0
            addSubview(label)
            return label
        }()
        
        emptyButton = {
            let btn = UIButton(type: UIButtonType.custom)
            btn.backgroundColor = RGB(0x00, 0xbf, 0x8f)
            btn.setTitleColor(UIColor.white, for: UIControlState.normal)
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.addTarget(self, action: #selector(didClickEmpty), for: UIControlEvents.touchUpInside)
            addSubview(btn)
            return btn
        }()
        
        setupConstraints()
    }
    
    func setupConstraints(){
        emptyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
        }
        
        emptyTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(emptyLabel)
            make.trailing.equalTo(emptyLabel)
            make.bottom.equalTo(emptyLabel.snp.top).offset(-11)
        }
        
        emptyImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.height.equalTo(130)
            make.bottom.equalTo(emptyTitleLabel.snp.top).offset(-20)
        }
        
        emptyButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(emptyLabel.snp.bottom).offset(15)
            make.width.equalTo(170)
            make.height.equalTo(40)
        }
    }
    
    func didClickEmpty() {
        emptyDelegate?.didClickEmptyButton()
    }
    
    func setImage(_ imageName: String, title: String?, text: String?) {
        emptyTitleLabel.text = text
        emptyTitleLabel.isHidden = false
        emptyLabel.font = UIFont.systemFont(ofSize: 12)
        setImage(imageName, text: text)
    }
    
    func setImage(_ imageName: String, text:String?) {
        emptyImageView.image = UIImage(named: imageName)?.reSizeImage(size: CGSize(width: 130, height: 130))
        emptyLabel.text = text
        emptyButton.isHidden = true
    }
    
    func setImage(_ imageName: String, text: String?, buttonTitle: String?) {
        emptyImageView.image = UIImage(named: imageName)?.reSizeImage(size: CGSize(width: 130, height: 130))
        emptyLabel.text = text
        emptyButton.isHidden = (buttonTitle == nil)
        emptyButton.setTitle(buttonTitle, for: UIControlState.normal)
    }
}
