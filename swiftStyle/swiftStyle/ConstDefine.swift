//
//  ConstDefine.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/7/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import Foundation
import UIKit

func RGB(_ r:CGFloat, _ g:CGFloat,_ b:CGFloat) -> UIColor {
    return RGBA(r,g,b,1.0);
}

func RGBA(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
