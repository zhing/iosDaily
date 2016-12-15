//
//  File.swift
//  swiftStyle
//
//  Created by Qing Zhang on 12/9/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import Foundation

//func bridge<T : AnyObject>(obj : T) -> UnsafeRawPointer {
//    return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
//}
//
//func bridge<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
//    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
//}
//
//func swift_getAssociatedObject<T: AnyObject> (base: AnyObject, key: Selector, initialize: ()->T) -> T{
//    if let associated = objc_getAssociatedObject(base, bridge(obj: key)) as? T {
//        return associated
//    }
//    
//    let associated = initialize()
//    objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
//    
//    return associated
//}
//
//func swift_setAssociatedObject<T: AnyObject>(base: AnyObject, key: Selector, value: T) {
//    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
//}
