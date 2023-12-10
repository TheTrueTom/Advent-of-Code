//
//  main.swift
//  2023.10
//
//  Created by Thomas Brichart on 10/12/2023.
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

/// Pipe connections in format (N, S, E, W)
let connections = [
    "|": "NS", // (n: 1, s: 1, e: 0, w: 0), // vertical pipe connecting north and south.
    "-": "EW", // (n: 0, s: 0, e: 1, w: 1), // horizontal pipe connecting east and west.
    "L": "NE", // (n: 1, s: 0, e: 1, w: 0), // 90-degree bend connecting north and east.
    "J": "NW", // (n: 1, s: 0, e: 0, w: 1), // 90-degree bend connecting north and west.
    "7": "SW", // (n: 0, s: 1, e: 0, w: 1), // 90-degree bend connecting south and west.
    "F": "SE" // (n: 0, s: 1, e: 1, w: 0), // 90-degree bend connecting south and east.
]

let directions = [
    "N": (-1, 0),
    "S": (1, 0),
    "E": (0, 1),
    "W": (0, -1)
]

func main() throws {
    let input = try readInput(fromTestFile: false).split(separator: "\n")
    
    let theMap = input.map { $0.split(separator: "").map { String($0) } }
    let Sposition = theMap.enumerated().filter { (i, v) in v.contains("S") }.map { ($0.offset, $0.element
        .firstIndex(of: "S")!.advanced(by: 0)) }[0]
    
    var possibleInitialDirections = [String]()
    
    for elt in "NSEW" {
        let initialDirection = String(elt)
        
        guard (0..<theMap.count).contains(Sposition.0 + directions[initialDirection]!.0) else { continue }
        guard (0..<theMap[Sposition.0 + directions[initialDirection]!.0].count).contains(Sposition.1 + directions[initialDirection]!.1) else { continue }
        
        let connection = theMap[Sposition.0 + directions[initialDirection]!.0][Sposition.1 + directions[initialDirection]!.1]
        
        // Check that we can go that direction
        guard connection != "." else { continue }
        if initialDirection == "N" && !"|7F".contains(connection) { continue }
        if initialDirection == "S" && !"|LJ".contains(connection) { continue }
        if initialDirection == "E" && !"-J7".contains(connection) { continue }
        if initialDirection == "W" && !"-LF".contains(connection) { continue }
        
        possibleInitialDirections.append(initialDirection)
    }
    
    guard possibleInitialDirections.count == 2 else { print("There is a problem"); return }
    
    var steps = 0
    var position = Sposition
    var direction = String(possibleInitialDirections[0])
    
    var allPositions = [position]
    
    while theMap[position.0][position.1] != "S" || steps == 0 {
        var symbol = theMap[position.0][position.1]
        
        if symbol == "S" {
            symbol = "NS".contains(direction) ? "|" : "-"
        }
        
        let connectionDirections = connections[symbol]!
        direction = connectionDirections.replacingOccurrences(of: direction.inverse(), with: "")
        position = (position.0 + directions[direction]!.0, position.1 + directions[direction]!.1)
        
        allPositions.append(position)
        
        steps += 1
    }

    let result1 = steps / 2
    
    print("Part1: \(result1)")
    
    var result2 = 0
    var inside = false
    
    for i in 0..<theMap.count {
        for j in 0..<theMap[0].count {
            // If it is a puzzle piece
            if let _ = allPositions.first(where: { $0 == (i, j) }) {
                // Vertical piece
                if "|F7S".contains(theMap[i][j]) {
                    inside.toggle()
                }
            } else {
                if inside {
                    result2 += 1
                }
            }
        }
    }
    
    print("Part2: \(result2)")
}

Timer.time(main)
