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
    
    return connections.filter { $0.value == direction }.keys.first!
}

func main() throws {
    let input = try readInput(fromTestFile: false).split(separator: "\n")
    
    var theMap = input.map { $0.split(separator: "").map { String($0) } }
    
    // Find the starting position
    let Sposition = theMap.enumerated().filter { (i, v) in v.contains("S") }.map { ($0.offset, $0.element
        .firstIndex(of: "S")!.advanced(by: 0)) }[0]
    
    // Replace the start position with the symbol it should be
    theMap[Sposition.0][Sposition.1] = sReplacement(map: theMap, sPosition: Sposition)
    
    var steps = 0
    var position = Sposition
    var direction = String(connections[theMap[Sposition.0][Sposition.1]]!.first!).inverse()
    
    // Map to indicate places where we are on the path for part 2
    var otherMap = [[String]](repeating: [String](repeating: "", count: theMap[0].count), count: theMap.count)
    otherMap[position.0][position.1] = "X"
    
    while position != Sposition || steps == 0 {
        var symbol = theMap[position.0][position.1]
        
        direction = connections[symbol]!.replacingOccurrences(of: direction.inverse(), with: "")
        position = (position.0 + directions[direction]!.0, position.1 + directions[direction]!.1)
        
        otherMap[position.0][position.1] = "X"
        steps += 1
    }
    
    let result1 = steps / 2
    
    print("Part1: \(result1)")
    
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
    
    print("Part2: \(result2)")
}

Timer.time(main)
