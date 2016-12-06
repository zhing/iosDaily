//
//  HttpClient.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/26/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import AFNetworking

enum HttpResponseType {
    case json
    case data
}

let httpServer :URL? = URL(string: "http://192.168.93.61:10001/")

class HttpClient: AFHTTPSessionManager {
    static let shareInstance = HttpClient(httpServer)
    
    /*
      *  指定构造器必须向上代理，便利构造器必须横向代理
      */
    private init(_ url: URL?) {
        super.init(baseURL: url, sessionConfiguration: nil)
        self.setHttpHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHttpHeader() {
        DispatchQueue.mainSync() {
            self.requestSerializer.setValue("7777", forHTTPHeaderField: "userID")
            self.requestSerializer.setValue("zhing7777", forHTTPHeaderField: "token")
            self.requestSerializer.setValue("V1.0", forHTTPHeaderField: "Version")
        }
    }
    
    class func setTimeout(timeout: TimeInterval) {
        DispatchQueue.mainSync() {
            shareInstance.requestSerializer.timeoutInterval = timeout
        }
    }
    
    class func setResponseType(type: HttpResponseType) {
        let contentTypes: Set<String> = ["application/json", "text/json", "text/javascript","text/plain"]
        
        DispatchQueue.mainSync() {
            if (type == .json) {
                shareInstance.requestSerializer = AFHTTPRequestSerializer();
                let serializer = AFJSONResponseSerializer();
                serializer.acceptableContentTypes = contentTypes;
                shareInstance.responseSerializer = serializer;
                shareInstance.setHttpHeader()
            }
            else if (type == .data) {
                shareInstance.requestSerializer = AFHTTPRequestSerializer();
                shareInstance.responseSerializer = AFHTTPResponseSerializer();
                shareInstance.setHttpHeader();
            }
        }
    }
}
