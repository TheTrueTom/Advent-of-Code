//
//  Day22.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

private class Brick: Comparable, Hashable, CustomStringConvertible {
    static func == (lhs: Brick, rhs: Brick) -> Bool {
        return lhs.s == rhs.s && lhs.f == rhs.f
    }
    
    static func < (lhs: Brick, rhs: Brick) -> Bool {
        min(lhs.s.z, lhs.f.z) < min(rhs.s.z, rhs.f.z)
    }
    
    var s: D3Point
    var f: D3Point
    
    init(s: D3Point, f: D3Point) {
        self.s = s
        self.f = f
    }
    
    func copy() -> Brick {
            return Brick(s: s, f: f)
        }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(s)
        hasher.combine(f)
    }
    
    var xRange: ClosedRange<Int> {
        min(s.x, f.x)...max(s.x, f.x)
    }
    
    var yRange: ClosedRange<Int> {
        min(s.y, f.y)...max(s.y, f.y)
    }
    
    var zRange: ClosedRange<Int> {
        min(s.z, f.z)...max(s.z, f.z)
    }
    
    func fillInMap(_ map: inout [[[Brick?]]]) {
        for x in xRange {
            for y in yRange {
                for z in zRange {
                    map[x][y][z] = self
                }
            }
        }
    }
    
    func eraseInMap(_ map: inout [[[Brick?]]]) {
        for x in xRange {
            for y in yRange {
                for z in zRange {
                    map[x][y][z] = nil
                }
            }
        }
    }
    
    func upstairsNeighbors(_ map: inout [[[Brick?]]]) -> [Brick] {
        var neighbours: Set<Brick> = []
        
        for x in xRange {
            for y in yRange {
                if let brick = map[x][y][zRange.upperBound + 1] {
                    neighbours.insert(brick)
                }
            }
        }
        
        return Array(neighbours)
    }
    
    func downstairsNeighbors(_ map: inout [[[Brick?]]]) -> [Brick] {
        var neighbours: Set<Brick> = []
        
        for x in xRange {
            for y in yRange {
                if let brick = map[x][y][zRange.lowerBound - 1] {
                    neighbours.insert(brick)
                }
            }
        }
        
        return Array(neighbours)
    }
    
    func movedDown(in map: inout [[[Brick?]]]) -> Bool {
        guard min(s.z - 1,  f.z - 1) > 0 else { return false }
        self.eraseInMap(&map)
        
        s = D3Point(s.x, s.y, s.z - 1)
        f = D3Point(f.x, f.y, f.z - 1)
        
        self.fillInMap(&map)
        
        return true
    }
    
    func canBeDisintegrated(in map: [[[Brick?]]]) -> Bool {
        var newMap = map
        
        let upstairsNeighbors = upstairsNeighbors(&newMap)
        
        self.eraseInMap(&newMap)
        
        for upstairsBrick in upstairsNeighbors {
            if upstairsBrick.downstairsNeighbors(&newMap).isEmpty {
                return false
            }
        }
        
        return true
    }
    
    var description: String {
        return "s: \(s) - f: \(f)"
    }
}

final class Day22: AOCDay {
    private let runTest = false
    private var bricks: [Brick]
    private var map: [[[Brick?]]]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        
        bricks = input.split(separator: "\n").enumerated().compactMap { (index, line) in
            let pattern = /(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/
            
            if let match = try? pattern.firstMatch(in: String(line)) {
                return Brick(s: D3Point(Int(match.1)!, Int(match.2)!, Int(match.3)!), f: D3Point(Int(match.4)!, Int(match.5)!, Int(match.6)!))
            }
            
            return nil
        }.sorted()
        
        let maxX = bricks.map { max($0.s.x, $0.f.x) }.max()!
        let maxY = bricks.map { max($0.s.y, $0.f.y) }.max()!
        let maxZ = bricks.map { max($0.s.z, $0.f.z) }.max()!
        
        map = [[[Brick?]]](repeating: [[Brick?]](repeating: [Brick?](repeating: nil, count: maxZ + 1), count: maxY + 1), count: maxX + 1)
        
        for brick in bricks {
            brick.fillInMap(&map)
        }
    }
    
    private func downTheBricks(_ bricks: [Brick], in map: inout [[[Brick?]]]) -> Int {
        var movedBricks = [Brick]()
        
        for brick in bricks {
            while brick.downstairsNeighbors(&map).isEmpty {
                guard brick.movedDown(in: &map) else { break }
                movedBricks.append(brick)
            }
        }
        
        return Set(movedBricks).count
    }
    
    private func printMap(_ map: [[[Brick?]]]) {
        for z in (0..<map[0][0].count).reversed() {
            var line = ""
            
            xLoop: for x in 0..<map.count {
                for y in 0..<map[0].count {
                    if map[x][y][z] != nil {
                        line += "#"
                        continue xLoop
                    }
                }
                
                line += " "
            }
            
            line += " | "
            
            yLoop: for y in 0..<map[0].count {
                for x in 0..<map.count {
                    if map[x][y][z] != nil {
                        line += "#"
                        continue yLoop
                    }
                }
                
                line += " "
            }
            
            print(line)
        }
        
    }

    func part1() -> Int {
        _ = downTheBricks(bricks, in: &map)
        
        return bricks.filter { $0.canBeDisintegrated(in: map) }.count
    }

    func part2() -> Int {
        var sum = 0
        
        for brick in bricks {
            var newMap = map
            var newBricks = bricks.map { $0.copy() }
            
            brick.eraseInMap(&newMap)
            
            if let idx = newBricks.firstIndex(where: {$0 == brick}) {
                newBricks.remove(at: idx)
            }
            
            sum += downTheBricks(newBricks, in: &newMap)
        }
        
        return sum
    }
}
