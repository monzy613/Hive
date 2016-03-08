//
//  GameViewController.swift
//  Hive
//
//  Created by 张逸 on 16/3/5.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var chessboardScrollView: Chessboard!
    @IBOutlet weak var p1chessbox: ChessBox!
    @IBOutlet weak var p2chessbox: ChessBox!

    override func viewDidLoad() {
        super.viewDidLoad()
        p1chessbox.playerType = Chess.P1
        p2chessbox.playerType = Chess.P2
        p1chessbox.CHESSNUM = CGFloat(logic!.chessnum)
        p2chessbox.CHESSNUM = CGFloat(logic!.chessnum)
        initChessboard()
        initObservers()
    }
    
    func initChessboard() {
        let frame = chessboardScrollView.frame
        chessboardScrollView.contentSize = CGSizeMake(frame.width * 2, frame.height * 2)
        chessboardScrollView.contentOffset = CGPointMake(frame.width / 2, frame.height / 2)
        chessboardScrollView.initX = frame.width
        chessboardScrollView.initY = frame.height
    }
    
    func initObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "oneChessSelected:", name: Const.OnChessSelected, object: nil)
    }
    
    func oneChessSelected(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let chessView = userInfo[Const.chessView] as? HexagonView {
                switch chessView.hiveType! {
                case .InHand:
                    chessboardScrollView.inHandChessSelected()
                    break
                case .OnBoard:
                    chessboardScrollView.onBoardChessSelected()
                    break
                default:
                    break
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
