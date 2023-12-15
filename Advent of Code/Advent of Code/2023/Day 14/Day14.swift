//
//  Day14.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

enum Tile: Character {
    case ground = "."
    case roundRock = "O"
    case squareRock = "#"
}

struct Point: Hashable {
    let x, y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func moved(direction: Direction) -> Point {
        switch direction {
        case .n:
            return Point(self.x, self.y - 1)
        case .s:
            return Point(self.x, self.y + 1)
        case .e:
            return Point(self.x + 1, self.y)
        case .w:
            return Point(self.x - 1, self.y)
        }
    }
}

enum Direction: String {
    case n, w, s, e
}

func calculateMass(input: [Point: Tile]) -> Int {
    let max = input.keys.compactMap { $0.y }.max()! + 1
    var sum = 0
    
    for point in input {
        if point.value == .roundRock {
            sum += max - point.key.y
        }
    }
    
    return sum
}

func tilt(_ platform: inout [Point: Tile], to direction: Direction) {
    var yRange = Array(0...platform.keys.compactMap { $0.x }.max()!)
    var xRange = Array(0...platform.keys.compactMap { $0.y }.max()!)
    
    switch direction {
    case .s:
        yRange = yRange.reversed()
    case .e:
        xRange = xRange.reversed()
    default:
        break
    }

    for y in yRange {
        for x in xRange {
            let point = Point(x, y)
            if platform[point]! == .roundRock {
                move(point, in: &platform, to: direction)
            }
        }
    }
}

func move(_ point: Point, in platform: inout [Point: Tile], to direction: Direction) {
    var point = point
    
    while true {
        let movedPoint = point.moved(direction: direction)
        
        if platform[movedPoint] == .ground {
            platform[movedPoint] = .roundRock
            platform[point] = .ground
            point = movedPoint
        } else {
            return
        }
    }
}

func cycle(_ platform: inout [Point: Tile]) {
    tilt(&platform, to: .n)
    tilt(&platform, to: .w)
    tilt(&platform, to: .s)
    tilt(&platform, to: .e)
}

final class Day14: AOCDay {
    private let runTest = false
    
    var thePlatform = [Point: Tile]()
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        let lines = input.split(separator: "\n")
        
        for (i, line) in lines.enumerated() {
            for (j, character) in line.enumerated() {
                thePlatform[Point(j, i)] = Tile(rawValue: character)
            }
        }
    }

    func part1() -> Int {
        var platform = thePlatform
        tilt(&platform, to: .n)
        
        return calculateMass(input: platform)

    }

    func part2() -> Int {
        var platform = thePlatform
        
        var cycleResult = [[Point: Tile]: Int]()
        
        var loopStart = 0
        var loopStop = 0
        
        for i in 1...1_000_000_000 {
            cycle(&platform)
            
            if let exists = cycleResult[platform] {
                loopStart = exists
                loopStop = i
                break
            } else {
                cycleResult[platform] = i
            }
        }
        
        let todo = (1_000_000_000 - loopStart) % (loopStop - loopStart)
        
        for i in 1...todo {
            cycle(&platform)
        }
        
        return calculateMass(input: platform)
    }
}
