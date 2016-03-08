//
//  Chessboard.swift
//  Hive
//
//  Created by 张逸 on 16/3/6.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit


/*
    u2
 u1    u3
    cc
 d1    d3
    d2
 */
enum Corner {
    case U1
    case U2
    case U3
    case D1
    case D2
    case D3
    
    func opposite() -> Corner {
        switch self {
        case .U1:
            return .D3
        case .U2:
            return .D2
        case .U3:
            return .D1
        case .D1:
            return .U3
        case .D2:
            return .U2
        case .D3:
            return .U1
        }
    }
    
    static func except(corners: [Corner]) -> [Corner] {
        var rtCorners: [Corner] = [.U1, .U2, .U3, .D1, .D2, .D3]
        for c in corners {
            if rtCorners.contains(c) {
                let index = rtCorners.indexOf(c)
                rtCorners.removeAtIndex(index!)
            }
        }
        return rtCorners
    }
    
    func leftAndRight() -> [Corner] {
        switch self {
        case .U1:
            return [.D1, .U2]
        case .U2:
            return [.U1, .U3]
        case .U3:
            return [.U2, .D3]
        case .D1:
            return [.U1, .D2]
        case .D2:
            return [.D1, .D3]
        case .D3:
            return [.D2, .U3]
        }
    }
}


class Chessboard: UIScrollView {
    var initX: CGFloat = 0
    var initY: CGFloat = 0
    var edgeLength: CGFloat {
        get {
            return initX / 10
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    
    func inHandChessSelected() {
        if logic!.started == false {
            let newPlace = HexagonView(edgeLength: initX / 10, center: CGPointMake(initX - edgeLength / 2, initY - edgeLength / 2), chess: Chess(playerType: -1, chessType: Const.newChess), hiveType: .EmptyPlace)
            newPlace.animate()
            self.addSubview(newPlace)
        } else {
            for chessView in logic!.chessOnBoard {
                showAvailablePlace(aroundChessView: chessView)
            }
        }
    }
 
    func onBoardChessSelected() {
        
    }
    
    func showAvailablePlace(aroundChessView chessView: HexagonView) {
        let newChess_playerType = logic!.selectedChess!.playerType
        let aroundChess_playerType = chessView.chess!.playerType
        if aroundChess_playerType != newChess_playerType {
            if logic!.chessOnBoard.count == 1 {
                newPlaceHexagon(withChess: chessView, andCorner: .U1)
                newPlaceHexagon(withChess: chessView, andCorner: .U2)
                newPlaceHexagon(withChess: chessView, andCorner: .U3)
                newPlaceHexagon(withChess: chessView, andCorner: .D1)
                newPlaceHexagon(withChess: chessView, andCorner: .D2)
                newPlaceHexagon(withChess: chessView, andCorner: .D3)
            } else {
                
            }
        } else if aroundChess_playerType == newChess_playerType {
            let relatedChesses = Array(chessView.relationDictionary.keys) as [Corner]
            let emptyPlaces = Corner.except(relatedChesses)
            for ep in emptyPlaces {
                for (key, value) in chessView.relationDictionary {
                    if key.leftAndRight().contains(ep) {
                        if value.chess?.playerType != newChess_playerType {
                            break
                        } else {
                            newPlaceHexagon(withChess: chessView, andCorner: ep)
                        }
                    } else {
                        newPlaceHexagon(withChess: chessView, andCorner: ep)
                    }
                }
            }
        }
    }
    
    func centerPoint(atCorner corner: Corner, withRelatedCenter center: CGPoint) -> CGPoint {
        switch corner {
        case .U1:
            return CGPointMake(center.x - (1 + MZCalculate.mzsin(degree: 30)) * edgeLength, center.y - MZCalculate.mzcos(degree: 30) * edgeLength)
        case .U2:
            return CGPointMake(center.x, center.y - 2 * MZCalculate.mzcos(degree: 30) * edgeLength)
        case .U3:
            return CGPointMake(center.x + (1 + MZCalculate.mzsin(degree: 30)) * edgeLength, center.y - MZCalculate.mzcos(degree: 30) * edgeLength)
        case .D1:
            return CGPointMake(center.x - (1 + MZCalculate.mzsin(degree: 30)) * edgeLength, center.y + MZCalculate.mzcos(degree: 30) * edgeLength)
        case .D2:
            return CGPointMake(center.x, center.y + 2 * MZCalculate.mzcos(degree: 30) * edgeLength)
        case .D3:
            return CGPointMake(center.x + (1 + MZCalculate.mzsin(degree: 30)) * edgeLength, center.y + MZCalculate.mzcos(degree: 30) * edgeLength)
        }
    }
    
    func newPlaceHexagon(withChess chessView: HexagonView, andCorner corner: Corner) {
        let newCenter = centerPoint(atCorner: corner, withRelatedCenter: chessView.myCenter!)
        let aroundChesses = chessesAround(point: newCenter)
        let newPlace = HexagonView(edgeLength: initX / 10, center: newCenter, chess: Chess(playerType: -1, chessType: Const.newChess), hiveType: .EmptyPlace)
        for chess in aroundChesses {
            if (chess.chess!.playerType != logic!.selectedChess?.playerType) && (logic!.chessOnBoard.count >= 2){
                return
            }
            if let chessCenter = chess.myCenter {
                if chessCenter.x < newCenter.x && chessCenter.y < newCenter.y {//u1
                    newPlace.relationDictionary[.U1] = chess
                } else if chessCenter.x == newCenter.x && chessCenter.y < newCenter.y {//u2
                    print("u2")
                    newPlace.relationDictionary[.U2] = chess
                } else if chessCenter.x > newCenter.x && chessCenter.y < newCenter.y {//u3
                    newPlace.relationDictionary[.U3] = chess
                } else if chessCenter.x < newCenter.x && chessCenter.y > newCenter.y {//d1
                    newPlace.relationDictionary[.D1] = chess
                } else if chessCenter.x == newCenter.x && chessCenter.y > newCenter.y {//d2
                    print("d2")
                    newPlace.relationDictionary[.D2] = chess
                } else if chessCenter.x > newCenter.x && chessCenter.y > newCenter.y {//d3
                    newPlace.relationDictionary[.D3] = chess
                }
            }
        }
        self.addSubview(newPlace)
        newPlace.animate()
    }
    
    func chessesAround(point point: CGPoint) -> [HexagonView] {
        var chesses: [HexagonView] = []
        for chess in logic!.chessOnBoard {
            if almostEqual(lh: chess.myCenter!, rh: point) {
                chesses.append(chess)
            }
        }
        return chesses
    }
    
    func almostEqual(lh lh: CGPoint, rh: CGPoint) -> Bool {
        let a = Double((lh.x - rh.x) * (lh.x - rh.x))
        let b = Double((lh.y - rh.y) * (lh.y - rh.y))
        let dis = sqrt(a + b)
        let diff = abs(dis - 2 * Double(edgeLength * MZCalculate.mzcos(degree: 30)))
        return diff < 0.1
    }
}
