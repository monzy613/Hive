//
//  ChessBox.swift
//  Hive
//
//  Created by 张逸 on 16/3/5.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

class Chess {
    static let INSECTS = [
        Chess.BEE: 1,
        Chess.ANT: 3,
        Chess.GRA: 3,
        Chess.SPI: 2,
        Chess.BTL: 2
    ]
    static let EXPANDS = [
        Chess.PILL: 1,
        Chess.MOS: 1,
        Chess.LBG: 1
    ]
    static let BEE = "bee"
    static let ANT = "ant"
    static let GRA = "grasshopper"
    static let SPI = "spider"
    static let BTL = "beetle"
    static let PILL = "pillworm"
    static let MOS = "mosquito"
    static let LBG = "ladybug"
    
    static let P1 = 0
    static let P2 = 1
    
    var maxAmount = 0
    var currentAmount = 0
    var playerType = -1
    var chessType = ""
    var movable = true
    
    init(playerType pt: Int, chessType ct: String) {
        self.playerType = pt
        self.chessType = ct
        self.maxAmount = Chess.INSECTS[ct] ?? 0
        currentAmount = maxAmount
    }
}

class ChessBox: UIScrollView {

    var CHESSNUM: CGFloat = 0
    var inset: CGFloat = 0
    var chessEdgeLength: CGFloat = 0
    var playerType = -1
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        inset = 0.1 * self.frame.height
        chessEdgeLength = 0.4 * self.frame.height
        self.contentSize = CGSizeMake((CGFloat(logic!.chessKindAmount) + 1) * inset + CGFloat(logic!.chessKindAmount) * 0.8 * self.frame.height, self.frame.height)
        if playerType == -1 {
            return
        }
        initChesses()
    }
    
    func initChesses() {
        if logic == nil {
            return
        }
        var sorted: [Chess] = []
        if playerType == Chess.P1 {
            sorted = (logic!.p1ChessBox).sort {
                c1, c2 in
                return c1.maxAmount < c2.maxAmount
            }
        } else {
            sorted = (logic!.p2ChessBox).sort {
                c1, c2 in
                return c1.maxAmount < c2.maxAmount
            }
        }
        for (i, chess) in sorted.enumerate() {
            let chessView = HexagonView(edgeLength: chessEdgeLength, center: CGPointMake(CGFloat(i + 1) * inset + chessEdgeLength * CGFloat(2 * i + 1), self.frame.height / 2), chess: chess, hiveType: .InHand)
            self.addSubview(chessView)
        }
    }

}
