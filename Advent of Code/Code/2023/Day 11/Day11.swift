//
//  Day11.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

func distance(_ in1: (Int, Int), _ in2: (Int, Int), addedRows: [Int], addedColumns: [Int], expansion: Int) -> Int {
    var distance = abs(in1.0 - in2.0) + abs(in1.1 - in2.1)
    
    for elt in addedRows {
        if (min(in1.0, in2.0)...max(in1.0, in2.0)).contains(elt) { distance += max(1, (expansion - 1)) }
    }
    
    for elt in addedColumns {
        if (min(in1.1, in2.1)...max(in1.1, in2.1)).contains(elt) { distance += max(1, (expansion - 1)) }
    }
    
    return distance
}

final class Day11: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    var theMap: [[String]]
    var galaxies: [(Int, Int)]
    
    var addedRows: [Int]
    var addedColumns: [Int]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        lines = input.split(separator: "\n")
        
        theMap = lines.map { $0.split(separator: "").map { String($0) } }
        
        addedRows = [Int]()
        addedColumns = [Int]()
        
        
        // Add rows when necessary
        for i in (0..<theMap.count).reversed() {
            if theMap[i].allSatisfy({$0 == "." }) {
                addedRows.append(i)
            }
        }
        
        // Add columns when necessary {
        for i in (0..<theMap[0].count).reversed() {
            if theMap.map({ $0[i] }).allSatisfy({$0 == "." }) {
                addedColumns.append(i)
            }
        }
        
        galaxies = [(Int, Int)]()
        
        // Find all galaxy coordinates
        for i in 0..<theMap.count {
            for j in 0..<theMap[0].count {
                if theMap[i][j] == "#" {
                    galaxies.append((i, j))
                }
            }
        }
    }

    func part1() -> Int {
        var distances = [Int]()
        
        for i in 0..<galaxies.count {
            for j in i+1..<galaxies.count {
                distances.append(distance(galaxies[i], galaxies[j], addedRows: addedRows, addedColumns: addedColumns, expansion: 1))
            }
        }
        
        return distances.sum
    }

    func part2() -> Int {
        var distances = [Int]()
        
        for i in 0..<galaxies.count {
            for j in i+1..<galaxies.count {
                distances.append(distance(galaxies[i], galaxies[j], addedRows: addedRows, addedColumns: addedColumns, expansion: 1_000_000))
            }
        }
        
        return distances.sum
    }
}
