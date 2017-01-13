//
//  IGTableViewSectionObject.swift
//  swiftStyle
//
//  Created by Qing Zhang on 1/12/17.
//  Copyright © 2017 Qing Zhang. All rights reserved.
//

import UIKit

class IGTableViewSectionObject: NSObject {
    
    var headerTitle :String?
    var footerTitle :String?
    
    lazy var items :Array<IGTableViewBaseItem> = []
    
    override init() {
        super.init()
    }
    
    init(itemArray : Array<IGTableViewBaseItem>) {
        super.init()
        
        items.append(contentsOf: itemArray)
    }
}
