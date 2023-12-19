//
//  Bitwise.swift
//  Advent of Code
//
//  Created by Thomas Brichart on 17/12/2023.
//

import Foundation

extension Int {
    func and(_ y: Int) -> Int {
        return Int(UInt16(self) & UInt16(y))
    }

    func not() -> Int {
        return Int(~UInt16(self))
    }

    func or(_ y: Int) -> Int {
        return Int(UInt16(self) | UInt16(y))
    }

    func left(by offset: Int) -> Int {
        return Int(UInt16(self) << offset)
    }

    func right(by offset: Int) -> Int {
        return Int(UInt16(self) >> offset)
    }
}

