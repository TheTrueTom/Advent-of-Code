//
//  Point.swift
//  Advent of Code
//
//  Created by Thomas Brichart on 16/12/2023.
//

import Foundation

struct Point: Hashable {
    public let x, y: Int
    public static let zero = Point(0, 0)
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    public func moved(direction: Direction, by amount: Int = 1) -> Point {
        switch direction {
        case .n:
            return Point(self.x, self.y - amount)
        case .s:
            return Point(self.x, self.y + amount)
        case .e:
            return Point(self.x + amount, self.y)
        case .w:
            return Point(self.x - amount, self.y)
        }
    }
}
