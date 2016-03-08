//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
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
                print(c)
            }
        }
        return rtCorners
    }
}

var emptyCorners = Corner.except([.U1, .D3])