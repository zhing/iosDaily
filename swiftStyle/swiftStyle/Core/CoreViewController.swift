//
//  CoreViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/26/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit


let TestNotification = "IGTestNotification"
class CoreViewController: UIViewController {
    var button01 :UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setupViews()
        setupObservers()
        unsafePointer()
    }
    
    func setupViews() {
        button01 = UIButton.init(type: UIButtonType.custom)
        button01.setTitle("postNoti", for: UIControlState.normal)
        button01.titleLabel?.textAlignment = NSTextAlignment.center
        button01.backgroundColor = UIColor.lightGray
        button01.addTarget(self, action: #selector(postNotification), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button01)
        button01.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.leading.equalTo(20)
            make.top.equalTo(100)
        }
    }
    
    func setupObservers() {
        _ = NotificationCenter.default.addObserver(observer: self, name: TestNotification, object: nil, queue: nil, handler: { (T, Notification) in
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func postNotification() {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: TestNotification)))
    }
    
    func unsafePointer() {
        let a = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        a.pointee = 42
        
        print("a's value: \(a.pointee)")
        a.deallocate(capacity: 1)
        
        var variable :Int = 4;
        immutableReceive(pointer: &variable) //in call parameters, can use &
        mutableReceive(mutablePointer: &variable)
        
        withUnsafeMutablePointer(to: &variable) {
            $0.pointee *= 2
        }
        
        /*
          * there is a special pointer: UnsafePointer<Void>/UnsafeRawPointer, how is casting between pointers
          */
        var intVariable = 4
        let intPtr :UnsafePointer<Int> = withUnsafePointer(to: &intVariable) { pointer in
            return pointer
        }
        let voidPtr :UnsafeRawPointer = UnsafeRawPointer(intPtr)
        let intPtrAgain = voidPtr.assumingMemoryBound(to: Int.self)
        immutableReceive(pointer: intPtrAgain)
        
        /*
          *  pointers array
          */
        let size = 10
        let array = UnsafeMutablePointer<Int>.allocate(capacity: size)
        for idx in 0..<10 {
            array.advanced(by: idx).pointee = idx
        }
        array.deallocate(capacity: size)
    }
    
    func immutableReceive(pointer: UnsafePointer<Int>) {
        print("param value is: \(pointer.pointee)")
    }
    
    func mutableReceive(mutablePointer: UnsafeMutablePointer<Int>) {
        mutablePointer.pointee *= 2
        print("param value is: \(mutablePointer.pointee)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
