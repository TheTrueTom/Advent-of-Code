//
//  2023-1.swift
//  Advent of Code
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

final class Day01: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        lines = input.split(separator: "\n")
    }

    func part1() -> Int {
        let result1 = lines.map { line in
            let nums = String(line).filter(\.isNumber)
            guard let f = nums.first, let l = nums.last else { return 0 }
            return Int("\(f)\(l)")!
        }.sum
        
        return result1
    }

    func part2() -> Int {
        let numbers = ["1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9]
        
        let result2 = lines.map { line in
            let indexes = numbers.keys.flatMap {
                var res: [(String.Index, String)] = []
                for elt in line.ranges(of: $0) {
                    res.append((elt.lowerBound, $0))
                }
                return res
            }
            
            let distances = indexes.compactMap {
                (line.distance(from:line.startIndex, to: $0.0), numbers[$0.1]!)
            }
                
            let sortedDistances = distances.sorted {
                $0.0 < $1.0
            }

            return Int("\(sortedDistances.first!.1)\(sortedDistances.last!.1)")!
        }.sum
        
        return result2
    }
}
