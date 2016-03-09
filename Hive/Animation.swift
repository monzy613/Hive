//
//  Animation.swift
//  Hive
//
//  Created by 张逸 on 16/3/9.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit
import pop


class MZAnim {
    static func move(object object: AnyObject, destPoint: CGPoint) {
        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        anim.springBounciness = 10
        anim.springSpeed = 7
        anim.toValue = NSValue(CGPoint: destPoint)
        object.pop_addAnimation(anim, forKey: "move")
    }
}