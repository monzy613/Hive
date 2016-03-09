//
//  Game.swift
//  Hive
//
//  Created by 张逸 on 16/3/5.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

class Const {
    //notification names
    static let OnChessSelected = "Monzy.OnChessSelected"
    static let OnChessDeselected = "Monzy.OnChessDeselected"
    static let OnChessPlaced = "Monzy.OnChessPlaced"
    static let TransitionFinish = "Monzy.TransitionFinish"
    
    //userinfo keys
    static let playerType = "Monzy.keys.playerType"
    static let sender = "Monzy.keys.senderHash"
    static let chessView = "Monzy.keys.ChessView"
    static let placedChess = "Monzy.keys.PlacedChess"
    
    //assets names
    static let BEE = "bee"
    static let ANT = "ant"
    static let GRA = "grasshopper"
    static let SPI_B = "spider-b"
    static let SPI_W = "spider-w"
    static let BTL = "beetle"
    static let PILL = "pillworm"
    static let MOS_B = "mosquito-b"
    static let MOS_W = "mosquito-w"
    static let LBG = "ladybug"
    static let newChess = "newChess"
    static let newPlace = "newPlace"
    static let background = "background"
    
    static let P1 = 0
    static let P2 = 1
    
    static let startGameSegue = "StartGameSegue"
}

class Logic {
    var started = false
    var chessKindAmount = 0 // 5 6 7 8
    var chessnum = 0
    var expands: [String: Int] = [:]
    var currentTurn: Int = Chess.P1
    var selectedChess: Chess?
    var selectedChessView: HexagonView?
    
    var tempChessViewBox: [HexagonView] = []
    var chessOnBoard: [HexagonView] = []
    var newPlaceses: [HexagonView] = []
    
    var p1ChessBox: [Chess] = []
    var p2ChessBox: [Chess] = []
    
    var autoMoveImageCenters: [PointPosition: CGPoint] = [:]
    
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
            let p2c = Chess(playerType: Chess.P2, chessType: insect)
            p1ChessBox.append(p1c)
            p2ChessBox.append(p2c)
            chessnum += amount
            chessKindAmount += 1
        }
    }
    
    func chessPlaced() {
        for p in newPlaceses {
            p.removeFromSuperview()
        }
        self.newPlaceses.removeAll()
    }
    
    func nextPlayer() {
        switch self.currentTurn {
        case Const.P1:
            self.currentTurn = Const.P2
        case Const.P2:
            self.currentTurn = Const.P1
        default:
            break
        }
    }
}