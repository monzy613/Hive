//
//  HexagonTransitionAnimator.swift
//  Hive
//
//  Created by 张逸 on 16/3/10.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

class HexagonTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        //1
        self.transitionContext = transitionContext
        
        //2
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! StartPageController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! GameViewController
        
        //3
        containerView!.addSubview(toViewController.view)
        
        //4
        let center = fromViewController.view.center
        let edgeLength: CGFloat = 20
        let hexagonMaskPathInitial = HexagonView.hexagonPath(center, edgeLength: edgeLength)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        let edgeLength2: CGFloat = screenSize.width > screenSize.height ?screenSize.width:screenSize.height
        let hexagonMaskPathFinal = HexagonView.hexagonPath(center, edgeLength: edgeLength2)
        
        //5
        let maskLayer = CAShapeLayer()
        maskLayer.path = hexagonMaskPathFinal.CGPath
        toViewController.view.layer.mask = maskLayer
        
        //6
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = hexagonMaskPathInitial.CGPath
        maskLayerAnimation.toValue = hexagonMaskPathFinal.CGPath
        maskLayerAnimation.duration = self.transitionDuration(transitionContext)
        maskLayerAnimation.delegate = self
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
    }
    
}
