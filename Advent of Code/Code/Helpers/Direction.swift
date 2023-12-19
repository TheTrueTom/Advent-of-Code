//
//  Direction.swift
//  Advent of Code
//
//  Created by Thomas Brichart on 16/12/2023.
//

import Foundation

enum Direction: String, CaseIterable, Hashable {
    case n, w, s, e
    
    static var cardinals: [Direction] {
        return [.n, .s, .w, .e]
    }
    
    public var opposite: Direction {
        switch self {
        case .n: .s
        case .s: .n
        case .w: .e
        case .e: .w
        }
    }
    
    public var perpendiculars: [Direction] {
        switch self {
        case .n: [.e, .w]
        case .s: [.e, .w]
        case .w: [.n, .s]
        case .e: [.n, .s]
        }
    }
    
    public var pointValue: Point {
        switch self {
        case .n: Point(1, 0)
        case .s: Point(-1, 0)
        case .w: Point(0, -1)
        case .e: Point(0, 1)
        }
    }
}
