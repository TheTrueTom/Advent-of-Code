//
//  main.swift
//  2023.9
//
//  Created by Thomas Brichart on 09/12/2023.
//

import Foundation

func nextNumber(_ input: [Int], forward: Bool = true) -> Int {
    guard !input.allSatisfy({ $0 == 0 }) else { return 0 }
    
    let differences = input.adjacentPairs().map { $1 - $0 }
    return forward ? input.last! + nextNumber(differences) : input.first! - nextNumber(differences, forward: false)
}

func main() throws {
    let input = try readInput(fromTestFile: false).split(separator: "\n")
    let nbInput = input.compactMap { $0.split(separator: " ").compactMap { Int($0) } }

    let result1 = nbInput.map { nextNumber($0) }.sum
    
    print("Part1: \(result1)")
    
    let result2 = nbInput.map { nextNumber($0, forward: false) }.sum
    
    print("Part2: \(result2)")
}

Timer.time(main)
