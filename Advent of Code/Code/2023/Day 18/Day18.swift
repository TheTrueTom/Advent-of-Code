//
//  Day18.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

final class Day18: AOCDay {
    struct DigInstruction {
        let direction: Direction
        let distance: Int
    }
    
    private let runTest = false
    private let lines: [String.SubSequence]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        lines = input.split(separator: "\n")
    }
    
    func area(instructions: [DigInstruction]) -> Int {
        var points = [Point]()
        var pos = Point.zero
        
        for instruction in instructions {
            pos = pos.moved(direction: instruction.direction, by: instruction.distance)
            points.append(pos)
        }
        
        var area = 0
        
        for i in 0..<points.count {
            area += (points[i].y * points[(i + 1) % points.count].x) - points[i].x * points[(i + 1) % points.count].y
        }
        
        area = abs(area) / 2
        
        let perimeter = instructions.map { $0.distance }.sum
        
        return area + perimeter / 2 + 1
    }

    func part1() -> Int {
        var instructions = [DigInstruction]()
        
        for line in lines {
            let elts = line.split(separator: " ")
            let direction: Direction = (elts[0] == "U") ? .n : (elts[0] == "D") ? .s : (elts[0] == "R") ? .e : .w
            instructions.append(DigInstruction(direction: direction, distance: Int(String(elts[1]))!))
        }
        
        let area = area(instructions: instructions)
        return area
    }

    func part2() -> Int {
        var instructions = [DigInstruction]()
        
        for line in lines {
            let code = line.split(separator: " ")[2].replacingOccurrences(of: "(#", with: "").replacingOccurrences(of: ")", with: "")
            let direction: Direction = (String(code)[5] == "3") ? .n : (String(code)[5] == "1") ? .s : (String(code)[5] == "0") ? .e : .w
            let distance = UInt64(String(code)[0...4], radix: 16)!
            instructions.append(DigInstruction(direction: direction, distance: Int(distance)))
        }
        
        let area = area(instructions: instructions)
        return area
    }
}
