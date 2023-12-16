//
//  Day16.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

// Using Direction & Point from Day 14

enum MirrorTile: Character {
    case none = "."
    case swneMirror = "\\"
    case nwseMirror = "/"
    case weSplitter = "-"
    case nsSplitter = "|"
}

struct Beam: Hashable {
    let position: Point
    let direction: Direction
}

func traceLightBeam(_ platform: [Point: MirrorTile], visited: inout [Point: Set<Direction>], beam: Beam) {
    let nextTile = beam.position.moved(direction: beam.direction)
    
    guard let _ = visited[nextTile] else {
        return
    }
    
    if let theVisit = visited[nextTile], theVisit.contains(beam.direction) {
        return
    }
    
    visited[nextTile]!.insert(beam.direction)
    
    switch platform[nextTile]! {
    case MirrorTile.none: // .
        traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: beam.direction))
    case .swneMirror: // \
        switch beam.direction {
        case .n:
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .w))
        case .w:
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .n))
        case .s:
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .e))
        case .e:
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .s))
        }
    case .nwseMirror: // /
        switch beam.direction {
        case .n:
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .e))
        case .w:
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .s))
        case .s:
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .w))
        case .e:
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .n))
        }
    case .nsSplitter: // |
        if beam.direction == .n || beam.direction == .s {
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: beam.direction))
        } else {
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .n))
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .s))
        }
    case .weSplitter: // -
        if beam.direction == .w || beam.direction == .e {
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: beam.direction))
        } else {
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .w))
            traceLightBeam(platform, visited: &visited, beam: Beam(position: nextTile, direction: .e))
        }
    }
}

func getEnergized(_ platform: [Point: MirrorTile], startingPoint: Beam) -> Int {
    var visited = [Point: Set<Direction>]()
    // Initialiser la grille des visités
    for (point, _) in platform {
        visited[point] = Set()
    }
    
    traceLightBeam(platform, visited: &visited, beam: startingPoint)

    return visited.filter { !$0.value.isEmpty }.count
}

final class Day16: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    private var thePlatform = [Point: MirrorTile]()
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput.replacingOccurrences(of: "↖︎", with: "\\") : input.replacingOccurrences(of: "↖︎", with: "\\")
        lines = input.split(separator: "\n")
        
        for (i, line) in lines.enumerated() {
            for (j, character) in line.enumerated() {
                thePlatform[Point(j, i)] = MirrorTile(rawValue: character)
            }
        }
    }

    func part1() -> Int {
        let startingPoint = Beam(position: Point(-1, 0), direction: .e)
        
        return getEnergized(thePlatform, startingPoint: startingPoint)
    }

    func part2() -> Int {
        var maxEnergy = 0
        
        let maxX = thePlatform.compactMap { $0.key.x }.max()!
        let maxY = thePlatform.compactMap { $0.key.y }.max()!
        
        for i in 0...maxX {
            var point = Point(i, -1)
            maxEnergy = max(maxEnergy, getEnergized(thePlatform, startingPoint: Beam(position: point, direction: .s)))
            
            point = Point(i, maxY + 1)
            maxEnergy = max(maxEnergy, getEnergized(thePlatform, startingPoint: Beam(position: point, direction: .n)))
        }
        
        for i in 0...maxY {
            var point = Point(-1, i)
            maxEnergy = max(maxEnergy, getEnergized(thePlatform, startingPoint: Beam(position: point, direction: .e)))
            
            point = Point(maxX + 1, i)
            maxEnergy = max(maxEnergy, getEnergized(thePlatform, startingPoint: Beam(position: point, direction: .w)))
        }
        
        return maxEnergy
    }
}
