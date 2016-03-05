//
//  GameViewController.swift
//  Hive
//
//  Created by 张逸 on 16/3/5.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var chessboardScrollView: UIScrollView!
    @IBOutlet weak var p1chessbox: ChessBox!
    @IBOutlet weak var p2chessbox: ChessBox!

    override func viewDidLoad() {
        super.viewDidLoad()
        logic = Logic(expands: [:])
        p1chessbox.playerType = Chess.P1
        p2chessbox.playerType = Chess.P2
        p1chessbox.CHESSNUM = CGFloat(logic!.chessnum)
        p2chessbox.CHESSNUM = CGFloat(logic!.chessnum)
        chessboardScrollView.delegate = self
        //chessboardScrollView.contentInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        let hv = HexagonView(edgeLength: 40, center: CGPointMake(100, 100), playerType: 1, chessType: Chess.BTL, withBadgeValue: 0)
        chessboardScrollView.addSubview(hv)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
