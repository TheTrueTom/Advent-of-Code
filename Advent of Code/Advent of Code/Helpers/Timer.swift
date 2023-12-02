//
//  Timer.swift
//  Advent of Code
//
//  Created by Thomas Brichart on 16/11/2023.
//

import Foundation

struct Timer {
    static func time(_ function: () throws -> Void) {
        let start = CFAbsoluteTimeGetCurrent()
        try! function()
        let diff = CFAbsoluteTimeGetCurrent() - start

        if diff < 0.001 {
            print("Execution time: \(String(format: "%.4f", diff*1000000)) \u{00B5}s")
        } else if diff < 1 {
            print("Execution time: \(String(format: "%.4f", diff*1000)) ms")
        } else {
            print("Execution time: \(String(format: "%.4f", diff)) seconds")
        }
    }
}
