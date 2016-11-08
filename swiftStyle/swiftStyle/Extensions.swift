//
//  Extensions.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/7/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    var appBkground :UIColor {return RGB(0xf2, 0xf2, 0xf2)}
    var appGreen :UIColor {return RGB(0x39, 0xbf, 0x9e)}
    var appRed : UIColor {return RGB(0xee, 0x6a, 0x6a)}
}

extension UIImage {
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
        return imageWithTintColor(tintColor: tintColor, blendMode: CGBlendMode.overlay)
    }
    
    func imageWithTintColor(tintColor: UIColor, blendMode: CGBlendMode) ->UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        tintColor.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return tintedImage!
    }
    
}
