//
//  Game.swift
//  Hive
//
//  Created by 张逸 on 16/3/5.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

class Logic {
    var chessKindAmount = 0 // 5 6 7 8
    var chessnum = 0
    var expands: [String: Int] = [:]
    
    var p1ChessBox: [Chess] = []
    var p2ChessBox: [Chess] = []
    
    init(expands: [String: Int]) {
        self.expands = expands
        for (insect, amount) in Chess.INSECTS {
            let p1c = Chess(playerType: Chess.P1, chessType: insect)
            let p2c = Chess(playerType: Chess.P2, chessType: insect)
            p1ChessBox.append(p1c)
            p2ChessBox.append(p2c)
            chessnum += amount
            chessKindAmount += 1
        }
        for (insect, amount) in expands {
            let p1c = Chess(playerType: Chess.P1, chessType: insect)
            let p2c = Chess(playerType: Chess.P1, chessType: insect)
            p1ChessBox.append(p1c)
            p2ChessBox.append(p2c)
            chessnum += amount
            chessKindAmount += 1
        }
    }
}