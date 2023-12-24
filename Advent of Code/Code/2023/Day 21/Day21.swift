//
//  Day21.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

private enum Tile: Character {
    case garden = "."
    case rock = "#"
}

final class Day21: AOCDay {
    private let runTest = false
    private var map = [Point: Tile]()
    private var startingPosition: Point = Point.zero
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        let lines = input.split(separator: "\n")
        
        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                if char == "S" {
                    startingPosition = Point(x, y)
                    map[Point(x, y)] = Tile.garden
                } else {
                    map[Point(x, y)] = Tile(rawValue: char)
                }
            }
        }
    }
    
    private func nextPossibleSteps(_ map: inout [Point: Tile], position: Point) -> [Point] {
        var result = [Point]()
        
        for direction in Direction.cardinals {
            let next = position.moved(direction: direction)
            
            if map.keys.contains(next) && map[next] != .rock {
                result.append(next)
            }
        }
        
        return result
    }

    func part1() -> Int {
        var previousPositions: Set<Point> = [startingPosition]
        
        for i in 1...64 {
            var positions: Set<Point> = []
            
            for pos in previousPositions {
                positions.formUnion(nextPossibleSteps(&map, position: pos))
            }
            
            previousPositions = positions
        }
        
        return previousPositions.count
    }

    func part2() -> Int {
        return 0
    }
}
