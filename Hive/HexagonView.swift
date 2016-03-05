//
//  HexagonView.swift
//  Hive
//
//  Created by 张逸 on 16/3/5.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

class HexagonView: UIView {
    
    var imageView: SpringImageView?
    var badgeLabel: UILabel?
    
    var isSelected = false
    var hasBadge = true
    var badgeValue = 0
    var edgeLength: CGFloat?
    
    
    
    func initBadge(withValue value: Int) {
        if value == 0 {
            return
        }
        let badgeWidth = (edgeLength ?? 0) / 2
        badgeLabel = UILabel(frame: CGRectMake(self.frame.minX + self.frame.width - badgeWidth, self.frame.minY, badgeWidth, badgeWidth))
        
        badgeLabel?.text = "\(value)"
        badgeLabel?.backgroundColor = UIColor.redColor()
        badgeLabel?.textColor = UIColor.whiteColor()
        badgeLabel?.textAlignment = .Center
        
        badgeLabel?.layer.cornerRadius = badgeWidth / 2
        badgeLabel?.clipsToBounds = true
        print(self.frame)
        
        self.addSubview(badgeLabel!)
    }
    
    func toggleSelected() {
        if isSelected == false {
            UIView.animateWithDuration(0.2, animations: {
                [unowned self] in
                self.layer.opacity = 0.5
                })
        } else {
            UIView.animateWithDuration(0.2, animations: {
                [unowned self] in
                self.layer.opacity = 1.0
                })
        }
        isSelected = !isSelected
    }
    
    func changeBadgeValue(newValue: Int) {
        if let bl = badgeLabel {
            bl.text = "\(newValue)"
        }
    }
    
    init(edgeLength: CGFloat, center: CGPoint, playerType: Int, chessType: String, withBadgeValue value: Int) {

        self.edgeLength = edgeLength
        badgeValue = value
        let x1 = center.x - edgeLength
        let x2 = center.x - 0.5 * edgeLength
        let x3 = center.x + 0.5 * edgeLength
        let x4 = center.x + edgeLength
        
        let y1 = center.y - edgeLength * cos(CGFloat(M_PI) / 6)
        let y2 = center.y
        let y3 = center.y + edgeLength * cos(CGFloat(M_PI) / 6)
        let bounds = CGRect(x: x1, y: y1, width: edgeLength * 2, height:  2 * edgeLength * cos(CGFloat(M_PI) / 6))
        
        super.init(frame: bounds)
        self.bounds = bounds
        
        let chessImage = UIImage(named: chessType)
        imageView = SpringImageView(image: chessImage)
        imageView?.frame = bounds
        imageView?.bounds = bounds
        
        let path = UIBezierPath()
        path.lineWidth = 2
        path.moveToPoint(CGPointMake(x2, y1))
        path.addLineToPoint(CGPointMake(x3, y1))
        path.addLineToPoint(CGPointMake(x4, y2))
        path.addLineToPoint(CGPointMake(x3, y3))
        path.addLineToPoint(CGPointMake(x2, y3))
        path.addLineToPoint(CGPointMake(x1, y2))
        path.addLineToPoint(CGPointMake(x2, y1))
        path.closePath()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.clearColor().CGColor
        shapeLayer.path = path.CGPath
        
        if playerType == Chess.P1 {
            imageView!.backgroundColor = UIColor.blackColor()
        } else {
            imageView!.backgroundColor = UIColor.whiteColor()
        }
        
        imageView!.layer.mask = shapeLayer
        imageView!.contentMode = .Center
        imageView!.image = imageWith(chessImage!, scaledToSize: CGSizeMake(edgeLength, edgeLength))
        imageView!.clipsToBounds = true
        imageView!.userInteractionEnabled = true
        self.addSubview(imageView!)
        initBadge(withValue: badgeValue)
    }
    
    func imageWith(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func randomPoint(width width: CGFloat, height: CGFloat) -> CGPoint {
        let x = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * width
        let y = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * height
        return CGPointMake(x, y)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        toggleSelected()
    }
    
    
}