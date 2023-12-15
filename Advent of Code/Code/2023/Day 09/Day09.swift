//
//  Day09.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

func nextNumber(_ input: [Int], forward: Bool = true) -> Int {
    guard !input.allSatisfy({ $0 == 0 }) else { return 0 }
    
    let differences = input.adjacentPairs().map { $1 - $0 }
    return forward ? input.last! + nextNumber(differences) : input.first! - nextNumber(differences, forward: false)
}

final class Day09: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    let nbInput: [[Int]]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        self.lines = input.split(separator: "\n")
        
        self.nbInput = self.lines.compactMap { $0.split(separator: " ").compactMap { Int($0) } }
    }

    func part1() -> Int {
        return nbInput.map { nextNumber($0) }.sum
    }

    func part2() -> Int {
        return nbInput.map { nextNumber($0, forward: false) }.sum
    }
}
