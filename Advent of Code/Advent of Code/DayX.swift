//
//  DayX.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

final class DayX: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        self.lines = input.split(separator: "\n")
    }

    func part1() -> Int {
        return 0
    }

    func part2() -> Int {
        return 0
    }
}
