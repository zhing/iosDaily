//
//  Extensions.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/7/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

extension UIColor {
    var appBkground :UIColor {return RGB(0xf2, 0xf2, 0xf2)}
    var appGreen :UIColor {return RGB(0x39, 0xbf, 0x9e)}
    var appRed : UIColor {return RGB(0xee, 0x6a, 0x6a)}
}

extension UIView {
    func addHorzLine(start: CGPoint, end: CGPoint, color:UIColor, borderWith: CGFloat) ->CALayer {
        let lineLayer = CALayer()
        lineLayer.frame = CGRect.init(origin: start, size: CGSize.init(width: end.x-start.x, height: borderWith))
        lineLayer.backgroundColor = color.cgColor
        self.layer.addSublayer(lineLayer)
        return lineLayer
    }
    
    func setFrameSize(size:CGSize) {
        self.frame = CGRect.init(origin: self.frame.origin, size: size)
    }
}

extension UIImage {
    
//    static func imageWithFill(color: UIColor, size: CGSize) ->UIImage{
//        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
//        color.setFill()
//        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height));
//        let fillImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return fillImage!;
//    }
    
    /**
     *  重设图片大小
     */
    func reSizeImage(size reSize:CGSize)->UIImage {
        let alphaInfo = self.cgImage!.alphaInfo;
        let opaque = (alphaInfo == CGImageAlphaInfo.none || alphaInfo == CGImageAlphaInfo.noneSkipFirst || alphaInfo == CGImageAlphaInfo.noneSkipLast)
        UIGraphicsBeginImageContextWithOptions(reSize, opaque, UIScreen.main.scale);
        self.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage!;
    }
    
    /*
      *tintColor
      */
    func imageWithTintColor(tintColor: UIColor) ->UIImage {
        return imageWithTintColor(tintColor: tintColor, blendMode: CGBlendMode.destinationIn)
    }
    
    func imageWithGradientTintColor(tintColor: UIColor) ->UIImage {
        return imageWithTintColor(tintColor: tintColor, blendMode: CGBlendMode.overlay) //保持灰度
    }
    
    func imageWithTintColor(tintColor: UIColor, blendMode: CGBlendMode) ->UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        tintColor.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        
        if blendMode != CGBlendMode.destinationIn { //保持透明度
            self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        }
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return tintedImage!
    }
    
    /*
     *blur
     */
    func imageWithBlur() -> UIImage {
        let stillImageFilter:GPUImageiOSBlurFilter = GPUImageiOSBlurFilter()
        return stillImageFilter.image(byFilteringImage: self)
    }
}
