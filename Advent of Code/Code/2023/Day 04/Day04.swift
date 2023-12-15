//
//  Day04.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

final class Day04: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    var resDic = [Int: Int]()
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        lines = input.split(separator: "\n")
    }

    func part1() -> Int {
        var result1 = 0
        
        for line in lines {
            let cardNumber = Int(line.split(separator: ":")[0].replacingOccurrences(of: "Card", with: "").replacingOccurrences(of: " ", with: ""))!
            let winningNumbers = Set(line.split(separator: ":")[1].split(separator: "|")[0].split(separator: " ").compactMap { Int($0)! })
            let userNumbers = Set(line.split(separator: ":")[1].split(separator: "|")[1].split(separator: " ").compactMap { Int($0)! })
            
            let commonNumbers = winningNumbers.intersection(userNumbers)
            result1 += 1 << (commonNumbers.count - 1)
            
            resDic[cardNumber] = commonNumbers.count
        }
        
        return result1
    }

    func part2() -> Int {
        var copies = [Int](repeating: 1, count: lines.count)
        
        // Loop over the cards
        for i in 0...lines.count-1 {
            // If we have to add cards
            if resDic[i+1]! > 0 {
                // Add cards along the following numbers
                for j in i+1...i+resDic[i+1]! {
                    // Add every time the number of cards needed (being the number of cards of the current considered card)
                    copies[j] += copies[i]
                }
            }
        }
        
        return copies.sum
    }
}
