//
//  FileHelper.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-22.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import Foundation

let RecordDirectoryName = "myRecords"

class FileHelper: NSObject {
   
    class func baseDirForRecords() -> String? {
        
        let allpaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        var document: String? = allpaths.first
        
        document = document?.appending("/" + RecordDirectoryName)
        
        var isDir: ObjCBool = false
        
        var pathSuccess: Bool = FileManager.default.fileExists(atPath: document!, isDirectory: &isDir)
        
        if (!pathSuccess || !isDir.boolValue) {
            
            do {
                try FileManager.default.createDirectory(atPath: document!, withIntermediateDirectories: true, attributes: nil)
                pathSuccess = true
            } catch _ {
                pathSuccess = false
            }
        }
        
        return pathSuccess ? document : nil
    }
    
    class func recordFileList() -> [AnyObject]? {
        
        let document: String? = baseDirForRecords()
        
        if document != nil {
            
            var error: NSError?
            
            var result: [AnyObject]?
            do {
                result = try FileManager.default.contentsOfDirectory(atPath: document!) as [AnyObject]?
            } catch let error1 as NSError {
                error = error1
                result = nil
            }
            if error != nil {
                print("error: \(error)")
            }
            else {
                return result
            }
        }
        
        return nil
    }
    
    class func recordPathWithName(name: String!) -> String? {
        
        let document: String? = baseDirForRecords()
//        let path: String? = document?.stringByAppendingPathComponent(name)
        let path:String? = document! + "/" + name
        return path
    }
    
    class func routesArray() -> [Route]! {
        
        let list: [AnyObject]? = recordFileList()
        
        if (list != nil) {
            
            var routeList: [Route] = []
            
            for file in list as![String] {
                
                print("file: \(file)")
                
                let path = recordPathWithName(name: file)
                let route = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as? Route
                
                if route != nil {
                    routeList.append(route!)
                }
            }
            
            return routeList
        }
        
        return []
    }
    
    class func deleteFile(file: String!) -> Bool! {
        let path = recordPathWithName(name: file)
        
        var error: NSError?
        var success: Bool
        do {
            try FileManager.default.removeItem(atPath: path!)
            success = true
        } catch let error1 as NSError {
            error = error1
            success = false
        }
        if error != nil {
            print("error: \(error)")
        }
        return success
    }
}
