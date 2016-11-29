//
//  FeedEntity.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/24/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit

class FeedEntity: NSObject {
    static var counter = 0
    var identifier :String!
    var title :String?
    var content :String?
    var username :String?
    var time :String?
    var imageName :String?
    
    init(_ dic :[String: String]?) {
        super.init()
        
        identifier = uniqueIdentifier
        title = dic?["title"]
        content = dic?["content"]
        username = dic?["username"]
        time = dic?["time"]
        imageName = dic?["imageName"]
    }
    
    var uniqueIdentifier :String {
        FeedEntity.counter += 1
        return "unique-id-\(FeedEntity.counter)"
    }
    
    override var description: String {
        return "\(identifier,title!, content!, username!, time!, imageName!)"
    }
}
