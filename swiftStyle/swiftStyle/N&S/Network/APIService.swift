//
//  APIService.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/26/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias APISuccessHandler = (_ responseObject: JSON?) ->Void
typealias APIFailureHandler = (_ error: String) ->Void
typealias Key = String
typealias Value = Any

enum HttpRequestTimeout : Int {
    case forDefault = 30
    case forUpload = 90
}

class APIService: NSObject {
    static var baseURL :URL? {
        return HttpClient.shareInstance.baseURL
    }
    
    class func absolutePath(path: String) -> String{
        return (baseURL?.absoluteString)! + path
    }
    
    class func POST(_ relativePath: String, params: [Key:Value?]?, success: APISuccessHandler?, failure: APIFailureHandler?) -> URLSessionTask? {
        let url = absolutePath(path: relativePath)
        HttpClient.setResponseType(type: HttpResponseType.json)
        HttpClient.setTimeout(timeout: TimeInterval(HttpRequestTimeout.forDefault.rawValue))
        let serviceTask = HttpClient.shareInstance.post(url,
                                                        parameters: params,
                                                        progress: nil,
                                                        success: {(task: URLSessionDataTask, responseObject: Any?) -> Void in
                                                            APIService.handleJsonSuccess(responseObject, success: success)
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            APIService.handleJsonFailure(error, failure: failure)
        })
        
        return serviceTask
    }
    
    class func GET(_ relativePath: String, params: [Key:Value?]?, success: APISuccessHandler?, failure: APIFailureHandler?) -> URLSessionTask? {
        let url = absolutePath(path: relativePath)
        HttpClient.setResponseType(type: HttpResponseType.json)
        HttpClient.setTimeout(timeout: TimeInterval(HttpRequestTimeout.forDefault.rawValue))
        let serviceTask = HttpClient.shareInstance.get(url,
                                                        parameters: params,
                                                        progress: nil,
                                                        success: {(task: URLSessionDataTask, responseObject: Any?) -> Void in
                                                            APIService.handleJsonSuccess(responseObject, success: success)
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            APIService.handleJsonFailure(error, failure: failure)
        })
        
        return serviceTask
    }
    
    class func handleJsonSuccess(_ responseObject: Any?, success: APISuccessHandler?) {
        if let success = success {
            if let response = responseObject {
                success(JSON(response))
            } else {
                success(nil)
            }
        }
    }

    class func handleJsonFailure(_ error: Error, failure: APIFailureHandler?) {
        if let failure = failure {
            failure(error.localizedDescription)
        }
    }
}
