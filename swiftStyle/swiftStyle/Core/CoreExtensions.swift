//
//  CoreExtensions.swift
//  swiftStyle
//
//  Created by Qing Zhang on 12/9/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import Foundation

public extension NotificationCenter {
    func addObserver<T: AnyObject>(observer: T, name aName: String, object anObject: AnyObject?, queue: OperationQueue? = OperationQueue.main, handler: @escaping (T, Notification) -> Void) -> AnyObject {
        let observation = addObserver(forName: NSNotification.Name(aName), object: anObject, queue: queue) { [unowned observer] note in
            handler(observer, note)
        }
        
        ObservationRemover(observation).makeRetainedBy(owner: observer)
        
        return observation
    }
}

private class ObservationRemover: NSObject {
    let observation: NSObjectProtocol
    
    init(_ obs: NSObjectProtocol) {
        observation = obs
        super.init()
    }
    
    func makeRetainedBy(owner: AnyObject) {
        observationRemoversForObject(object: owner).add(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observation)
    }
}

private var ObservationRemoverKey: UnsafeRawPointer?

private func observationRemoversForObject(object: AnyObject) -> NSMutableArray {
    if ObservationRemoverKey == nil {
        withUnsafePointer(to: &ObservationRemoverKey) { pointer in
            ObservationRemoverKey = UnsafeRawPointer(pointer)
        }
    }
    
    var retainedRemovers = objc_getAssociatedObject(object, ObservationRemoverKey) as! NSMutableArray?
    if retainedRemovers == nil {
        retainedRemovers = NSMutableArray()
        objc_setAssociatedObject(object, ObservationRemoverKey, retainedRemovers, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    return retainedRemovers!
}
