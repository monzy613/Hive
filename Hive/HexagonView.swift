//
//  HexagonView.swift
//  Hive
//
//  Created by 张逸 on 16/3/5.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

class HexagonView: UIView {
    enum HiveType {
        case InHand
        case OnBoard
        case EmptyPlace
    }
    
    var chess: Chess?
    var imageView: SpringImageView?
    var badgeLabel: UILabel?
    var myCenter: CGPoint?
    
    var isSelected = false
    var hasBadge = true
    var badgeValue = 0
    var edgeLength: CGFloat?
    var hiveType: HiveType?
    
    var relationDictionary: [Corner: HexagonView] = [:]
    
    
    func initBadge(withValue value: Int) {
        if hasBadge == false {
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
        
        self.addSubview(badgeLabel!)
    }
    
    func chessPlacedOne() {
        if badgeValue == 0 {
            return
        }
        badgeValue -= 1
        badgeLabel?.text = "\(badgeValue)"
        if badgeValue == 0 && hiveType == .InHand {
            UIView.animateWithDuration(0.2, animations: {
                [unowned self] in
                self.layer.opacity = 0.5
                })
        }
    }
    
    func animate() {
        imageView?.animation = "pop"
        imageView?.curve = "easeIn"
        imageView?.duration = 0.5
        imageView?.repeatCount = 9999
        imageView?.animate()
    }
    
    func stopAnimate() {
        imageView?.layer.removeAllAnimations()
        if badgeValue == 0 && hiveType == .InHand {
            return
        }
        UIView.animateWithDuration(0.2, animations: {
            [unowned self] in
            self.layer.opacity = 1.0
            })
    }
    
    func toggleSelected() {
        if let logic = logic, chess = chess {
            if logic.currentTurn != chess.playerType {
                return
            }
        }
        if isSelected == false {
            logic?.selectedChess = self.chess
            NSNotificationCenter.defaultCenter().postNotificationName(Const.OnChessSelected, object: nil, userInfo: [Const.playerType: chess!.playerType, Const.sender: self.hashValue, Const.chessView: self])
            animate()
            UIView.animateWithDuration(0.2, animations: {
                [unowned self] in
                self.layer.opacity = 0.5
                })
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(Const.OnChessDeselected, object: nil, userInfo: nil)
            logic?.selectedChess = nil
            stopAnimate()
            
        }
        isSelected = !isSelected
    }
    
    func changeBadgeValue(newValue: Int) {
        if let bl = badgeLabel {
            bl.text = "\(newValue)"
        }
    }
    
    init(edgeLength: CGFloat, center: CGPoint, chess: Chess, hiveType: HiveType) {
        self.myCenter = center
        self.edgeLength = edgeLength
        self.chess = chess
        hasBadge = (hiveType == .InHand)
        badgeValue = chess.maxAmount
        self.hiveType = hiveType
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
        
        var chessAssetName = chess.chessType
        
        switch chess.chessType {
        case Chess.SPI:
            switch chess.playerType {
            case Chess.P1:
                chessAssetName = Const.SPI_W
            case Chess.P2:
                chessAssetName = Const.SPI_B
            default:
                break
            }
        case Chess.MOS:
            switch chess.playerType {
            case Chess.P1:
                chessAssetName = Const.MOS_W
            case Chess.P2:
                chessAssetName = Const.MOS_B
            default:
                break
            }
        default:
            break
        }
        
        let chessImage = UIImage(named: chessAssetName)
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
        
        if chess.playerType == Chess.P1 {
            imageView!.backgroundColor = UIColor.blackColor()
        } else if chess.playerType == Chess.P2 {
            imageView!.backgroundColor = UIColor.whiteColor()
        } else {
            imageView!.backgroundColor = UIColor.redColor()
        }
        
        imageView!.layer.mask = shapeLayer
        imageView!.contentMode = .Center
        imageView!.image = imageWith(chessImage!, scaledToSize: CGSizeMake(edgeLength, edgeLength))
        imageView!.clipsToBounds = true
        imageView!.userInteractionEnabled = true
        self.addSubview(imageView!)
        initObservers()
        if hiveType == .EmptyPlace {
            return
        }
        
        initBadge(withValue: badgeValue)
    }
    
    func imageWith(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func initObservers() {
        /*
        if hiveType! == .EmptyPlace {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "onChessDeselected", name: Const.OnChessDeselected, object: nil)
            return
        }
        */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newChessSelected:", name: Const.OnChessSelected, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "chessPlaced:", name: Const.OnChessPlaced, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onChessDeselected", name: Const.OnChessDeselected, object: nil)
    }
    
    
    func newChessSelected(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if userInfo[Const.sender] as! Int == self.hashValue {
                return
            } else {
                if let pt = userInfo[Const.playerType] as? Int {
                    if pt == chess?.playerType && self.isSelected == true {
                        toggleSelected()
                    }
                }
            }
        }
    }
    
    func chessPlaced(notification: NSNotification) {
        if self.hiveType == .InHand {
            if let placedChess = notification.userInfo![Const.placedChess] as? Chess {
                if placedChess.playerType == self.chess?.playerType && placedChess.chessType == self.chess?.chessType {
                    chessPlacedOne()
                }
            }
        }
        if self.isSelected == true {
            toggleSelected()
        }
    }
    
    func onChessDeselected() {
        if hiveType! == .EmptyPlace {
            self.removeFromSuperview()
        }
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
        self.superview?.bringSubviewToFront(self)
        switch hiveType! {
        case .InHand:
            if self.badgeValue != 0 {
                toggleSelected()
            }
            break
        case .OnBoard:
            toggleSelected()
            break
        case .EmptyPlace:
            stopAnimate()
            let newChess = HexagonView(edgeLength: edgeLength ?? 0, center: myCenter ?? CGPointMake(0, 0), chess: logic!.selectedChess!, hiveType: .OnBoard)
            self.superview!.addSubview(newChess)
            newChess.relationDictionary = self.relationDictionary
            for (corner, chessV) in newChess.relationDictionary {
                chessV.relationDictionary[corner.opposite()] = newChess
            }
            self.removeFromSuperview()
            NSNotificationCenter.defaultCenter().postNotificationName(Const.OnChessPlaced, object: nil, userInfo: [Const.placedChess: logic!.selectedChess!])
            logic!.chessOnBoard.append(newChess)
            logic!.started = true
            logic?.nextPlayer()
        }
    }
    
    
}