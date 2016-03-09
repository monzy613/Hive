//
//  StartPageController.swift
//  Hive
//
//  Created by 张逸 on 16/3/9.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit


class MZNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HexagonTransitionAnimator()
    }
}

enum PointPosition {
    case Left
    case Up
    case Right
    case Down
    case Center
    mutating func next() -> PointPosition {
        switch self {
        case .Left:
            self = .Up
        case .Up:
            self = .Right
        case .Right:
            self = .Down
        case .Down:
            self = .Left
        default:
            break
        }
        return self
    }
}

class AutoMoveImageView: SpringImageView {
    var pos: PointPosition?
}

class StartPageController: UIViewController {
    @IBOutlet weak var logoImageView: SpringImageView!
    @IBOutlet weak var startButton: DesignableButton!
    @IBOutlet weak var hAMimageView: AutoMoveImageView!
    @IBOutlet weak var iAMimageView: AutoMoveImageView!
    @IBOutlet weak var eAMimageView: AutoMoveImageView!
    @IBOutlet weak var vAMimageView: AutoMoveImageView!
    
    var animationTimer: NSTimer?
    
    @IBAction func startButtonPressed(sender: DesignableButton) {
        //stop animation
        
        animationTimer?.invalidate()
        animationTimer = nil
        let buttonHighlightedImage = startButton.backgroundImageForState(.Highlighted)
        let buttonHighlightedTitleColor = startButton.titleColorForState(.Highlighted)
        startButton.setBackgroundImage(buttonHighlightedImage, forState: .Normal)
        startButton.setTitleColor(buttonHighlightedTitleColor, forState: .Normal)
        self.navigationController?.topViewController?.performSegueWithIdentifier(Const.startGameSegue, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = startButton.frame.height / 10
        initHiveAnim()
        // Do any additional setup after loading the view.
    }
    
    func initHiveAnim() {
        let logoSize = logoImageView.bounds.size
        let logoCenter = logoImageView.center
        print(logoSize)
        let xOffset = logoSize.width * 0.2865
        let yOffset = logoSize.width * 0.1768
        
        logic!.autoMoveImageCenters.removeAll()
        logic!.autoMoveImageCenters[.Left] = CGPointMake(logoCenter.x - xOffset, logoCenter.y)
        logic!.autoMoveImageCenters[.Up] = CGPointMake(logoCenter.x, logoCenter.y - yOffset)
        logic!.autoMoveImageCenters[.Right] = CGPointMake(logoCenter.x + xOffset, logoCenter.y)
        logic!.autoMoveImageCenters[.Down] = CGPointMake(logoCenter.x, logoCenter.y + yOffset)
        logic!.autoMoveImageCenters[.Center] = logoCenter
        
        MZAnim.move(object: hAMimageView, destPoint: (logic!.autoMoveImageCenters)[.Left]!)
        hAMimageView.pos = .Left
        MZAnim.move(object: iAMimageView, destPoint: (logic!.autoMoveImageCenters)[.Up]!)
        iAMimageView.pos = .Up
        MZAnim.move(object: eAMimageView, destPoint: (logic!.autoMoveImageCenters)[.Right]!)
        eAMimageView.pos = .Right
        MZAnim.move(object: vAMimageView, destPoint: (logic!.autoMoveImageCenters)[.Down]!)
        vAMimageView.pos = .Down
        animationTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "animateImages", userInfo: nil, repeats: true)
    }
    
    func animateImages() {
        MZAnim.move(object: hAMimageView, destPoint: (logic!.autoMoveImageCenters)[hAMimageView.pos!.next()]!)
        MZAnim.move(object: iAMimageView, destPoint: (logic!.autoMoveImageCenters)[iAMimageView.pos!.next()]!)
        MZAnim.move(object: eAMimageView, destPoint: (logic!.autoMoveImageCenters)[eAMimageView.pos!.next()]!)
        MZAnim.move(object: vAMimageView, destPoint: (logic!.autoMoveImageCenters)[vAMimageView.pos!.next()]!)
    }
}
