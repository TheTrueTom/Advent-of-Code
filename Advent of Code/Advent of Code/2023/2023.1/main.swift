//
//  main.swift
//  2023.1
//
//  Created by Thomas Brichart on 16/11/2023.
//

import Foundation

func main() throws {
    let lines = try readInput(fromTestFile: false).split(separator: "\n")
    
    let result1 = lines.map { line in
        let nums = String(line).filter(\.isNumber)
        guard let f = nums.first, let l = nums.last else { return 0 }
        return Int("\(f)\(l)")!
    }.reduce(0, +)
    
    print("Part1: \(result1)")
    
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
    }.reduce(0, +)
    
    print("Part2: \(result2)")
}

Timer.time(main)
