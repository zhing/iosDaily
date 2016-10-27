//
//  GestureViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 10/27/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit

class GestureViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var responseView: UIView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gestureView.isUserInteractionEnabled = true
        tapGesture.delegate = self
        gestureView.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        print("tap point:\(sender.location(in: gestureView))")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: responseView)
        if responseView.bounds.contains(touchPoint){
            return true
        }
        return false
    }
}
