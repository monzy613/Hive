//
//  Calculate.swift
//  Hive
//
//  Created by 张逸 on 16/3/8.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

class MZCalculate {
    static func rad(deg: Double) -> Double {
        return deg * M_PI / 180
    }
    
    static func mzcos(degree deg: Double) -> CGFloat {
        let rad = MZCalculate.rad(deg)
        return CGFloat(cos(rad))
    }
    
    static func mzsin(degree deg: Double) -> CGFloat {
        let rad = MZCalculate.rad(deg)
        return CGFloat(sin(rad))
    }
}