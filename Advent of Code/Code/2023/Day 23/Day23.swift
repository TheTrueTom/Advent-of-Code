//
//  Day23.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

private enum Tile: Character, CaseIterable {
    case path = "."
    case downUp = "^"
    case downDown = "v"
    case downRight = ">"
    case downLeft = "<"
    
    var dirs: [Direction] {
        switch self {
        case .downDown:
            return [.s]
        case .downLeft:
            return [.w]
        case .downRight:
            return [.e]
        case .downUp:
            return [.n]
        case .path:
            return Direction.cardinals
        }
    }
}

private class Node {
    let pos: Point
    let type: Tile
    var neighbors: [Point: Int] = [:]
    
    init(pos: Point, type: Tile) {
        self.pos = pos
        self.type = type
    }
}

private struct BFSNode: Comparable {
    static func < (lhs: BFSNode, rhs: BFSNode) -> Bool {
        return lhs.length < rhs.length
    }
    
    let pos: Point
    let length: Int
    let visited: [Point]
}

final class Day23: AOCDay {
    private let runTest = false
    private let input: String
    
    private var start = Point.zero
    private var finish = Point.zero
    
    init(input: String, testInput: String) {
        self.input = runTest ? testInput : input
    }
    
    private func buildMap(ignoreSlopes: Bool = false) -> [Point: Node] {
        var map = [Point: Node]()
        
        for (y, line) in input.split(separator: "\n").enumerated() {
            for (x,char) in line.enumerated() {
                if (Tile.allCases.map { $0.rawValue }).contains(char) {
                    let tile = ignoreSlopes ? Tile.path : Tile(rawValue: char)!
                    map[Point(x, y)] = Node(pos: Point(x, y), type: tile)
                }
            }
        }
        
        start = map.keys.first(where: { $0.y == 0 })!
        finish = map.keys.first(where: { $0.y == input.split(separator: "\n").count - 1})!
        
        for (key, _) in map {
            for dir in Direction.cardinals {
                if map.keys.contains(key.moved(direction: dir)) {
                    map[key]?.neighbors[key.moved(direction: dir)] = 1
                }
            }
        }
        
        compressMap(&map)
        
        return map
    }
    
    private func printMap(_ map: [Point: Node]) {
        let xMax = map.keys.map { $0.x }.max()!
        let yMax = map.keys.map { $0.x }.max()!
        
        for y in 0...yMax {
            var line = ""
            for x in 0...xMax {
                if let _ = map[Point(x, y)] {
                    line += "."
                } else {
                    line += " "
                }
            }
            print(line)
        }
    }
    
    private func compressMap(_ map: inout [Point: Node]) {
        var keysToRemove = [Point]()
        
        for (key, value) in map {
            if value.type != .path { continue }
            
            if value.neighbors.count == 2 && value.neighbors.keys.allSatisfy( { map[$0]!.type == .path }) {
                let nei = Array(value.neighbors.keys)
                
                map[nei[0]]?.neighbors.removeValue(forKey: key)
                map[nei[1]]?.neighbors.removeValue(forKey: key)
                
                map[nei[0]]?.neighbors[nei[1]] = value.neighbors.values.sum
                map[nei[1]]?.neighbors[nei[0]] = value.neighbors.values.sum
                
                keysToRemove.append(key)
            }
        }
        
        for key in keysToRemove {
            map.removeValue(forKey: key)
        }
    }
    
    private func longestPath(in map: inout [Point: Node], from start: Point, to finish: Point) -> Int {
        var longestRun = 0
        
        var toVisit = PriorityQueue<BFSNode>(ascending: true, startingValues: [BFSNode(pos: start, length: 0, visited: [Point]())])
        
        while let visiting = toVisit.pop() {
            if visiting.pos == finish {
                longestRun = max(longestRun, visiting.length)
                continue
            }
            
            for neighbor in map[visiting.pos]!.neighbors {
                if visiting.visited.contains(neighbor.key) { continue }
                
                var vis = visiting.visited
                vis.append(visiting.pos)
                
                if map[visiting.pos]!.type == .path {
                    toVisit.push(BFSNode(pos: neighbor.key, length: visiting.length + neighbor.value, visited: vis))
                } else {
                    if neighbor.key == visiting.pos.moved(direction: map[visiting.pos]!.type.dirs[0]) {
                        toVisit.push(BFSNode(pos: neighbor.key, length: visiting.length + neighbor.value, visited: vis))
                    }
                }
            }
        }
        
        return longestRun
    }

    func part1() -> Int {
        var map = buildMap()
        return longestPath(in: &map, from: start, to: finish)
    }

    func part2() -> Int {
        var map = buildMap(ignoreSlopes: true)
        return longestPath(in: &map, from: start, to: finish)
    }
}
