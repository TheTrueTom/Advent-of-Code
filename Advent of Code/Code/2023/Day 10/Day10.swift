//
//  Day10.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

extension String {
    func inverse() -> String {
        if self == "N" { return "S" }
        else if self == "S" { return "N" }
        else if self == "W" { return "E" }
        else if self == "E" { return "W" }
        else { return "" }
    }
}

final class Day10: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    let connections = [
        "|": "NS",
        "-": "EW",
        "L": "EN",
        "J": "NW",
        "7": "SW",
        "F": "ES"
    ]

    let directions = [
        "N": (-1, 0),
        "S": (1, 0),
        "E": (0, 1),
        "W": (0, -1)
    ]
    
    var theMap: [[String]]
    var otherMap: [[String]]
    let Sposition: (Int, Int)
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        lines = input.split(separator: "\n")
        
        theMap = lines.map { $0.split(separator: "").map { String($0) } }
        
        // Find the starting position
        Sposition = theMap.enumerated().filter { (i, v) in v.contains("S") }.map { ($0.offset, $0.element
            .firstIndex(of: "S")!.advanced(by: 0)) }[0]
        
        otherMap = [[String]](repeating: [String](repeating: "", count: theMap[0].count), count: theMap.count)
    }
    
    func sReplacement(map: [[String]], sPosition: (Int, Int)) -> String {
        var sConnections = [String]()
        
        if "|F7".contains(map[sPosition.0 - 1][sPosition.1]) {
            sConnections.append("N")
        }
        
        if "|JL".contains(map[sPosition.0 + 1][sPosition.1]) {
            sConnections.append("S")
        }
        
        if "-FL".contains(map[sPosition.0][sPosition.1 - 1]) {
            sConnections.append("W")
        }
        
        if "-J7".contains(map[sPosition.0][sPosition.1 + 1]) {
            sConnections.append("E")
        }
        
        let direction = sConnections.sorted().joined()
        
        return self.connections.filter { $0.value == direction }.keys.first!
    }

    func part1() -> Int {
        // Replace the start position with the symbol it should be
        theMap[Sposition.0][Sposition.1] = sReplacement(map: theMap, sPosition: Sposition)
        
        var steps = 0
        var position = Sposition
        var direction = String(connections[theMap[Sposition.0][Sposition.1]]!.first!).inverse()
        
        otherMap[position.0][position.1] = "X"
        
        while position != Sposition || steps == 0 {
            let symbol = theMap[position.0][position.1]
            
            direction = connections[symbol]!.replacingOccurrences(of: direction.inverse(), with: "")
            position = (position.0 + directions[direction]!.0, position.1 + directions[direction]!.1)
            
            otherMap[position.0][position.1] = "X"
            steps += 1
        }
        
        return steps / 2
    }

    func part2() -> Int {
        var result2 = 0
        var inside = false
        
        for i in 0..<theMap.count {
            for j in 0..<theMap[0].count {
                // If it is a puzzle piece
                if !otherMap[i][j].isEmpty {
                    // Vertical piece
                    if "|F7".contains(theMap[i][j]) {
                        inside.toggle()
                    }
                } else {
                    if inside {
                        result2 += 1
                    }
                }
            }
        }
        
        return result2
    }
}
