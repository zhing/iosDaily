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
    
    var frameSize :CGSize {
        get { return self.bounds.size }
        set {
            self.frame = CGRect.init(origin: self.frame.origin, size: newValue)
        }
    }
    
    var frameX :CGFloat {
        get { return self.frame.origin.x }
        set {
            self.frame = CGRect(origin: CGPoint(x: newValue, y: self.frame.origin.y), size: self.bounds.size)
        }
    }
    
    var frameY :CGFloat {
        get { return self.frame.origin.y }
        set {
            self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: newValue), size: self.bounds.size)
        }
    }
    
    var frameWidth :CGFloat {
        get {return self.frame.size.width}
        set {
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: newValue, height: self.frame.size.height))
        }
    }
    
    var frameHeight :CGFloat {
        get { return self.frame.size.height }
        set {
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.size.width, height: newValue))
        }
    }
}

extension UIImage {
    
    static func imageWithColor(fillColor: UIColor, size: CGSize) ->UIImage {
        return UIImage.imageWithFill(fillColor: fillColor, strokeColor: nil, size: size, lineWidth: 0, cornerRadius: 0)
    }
    
    static func roundedImageWithColor(fillColor: UIColor, size: CGSize, cornerRadius: CGFloat)->UIImage {
        return UIImage.imageWithFill(fillColor: fillColor, strokeColor: nil, size: size, lineWidth: 0, cornerRadius: cornerRadius)
    }
    
    static func imageWithFill(fillColor: UIColor, strokeColor: UIColor?, size: CGSize, lineWidth: CGFloat, cornerRadius: CGFloat) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        fillColor.setFill()
        strokeColor?.setStroke()
        let roundedRect = CGRect.init(x: lineWidth/2, y: lineWidth/2, width: size.width-lineWidth, height: size.height-lineWidth)
        let path = UIBezierPath.init(roundedRect: roundedRect, cornerRadius: cornerRadius)
        path.lineWidth = lineWidth
        path.fill()
        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
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
    
    func resizeImageByScale() ->UIImage {
        let targetWidth = self.size.width * self.scale / UIScreen.main.scale
        let targetHeight = self.size.height * self.scale / UIScreen.main.scale
        return reSizeImage(size: CGSize(width: targetWidth, height: targetHeight))
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


extension UIScrollView {
    func setInsetTop(_ insetTop: CGFloat) {
        var inset = self.contentInset
        inset.top = insetTop
        self.contentInset = inset
    }
}

extension DispatchQueue {
    
    class func mainSync(_ clourse: ()->Void) {
        if Thread.isMainThread {
            clourse()
        } else {
            DispatchQueue.main.sync {
                clourse()
            }
        }
    }
}
