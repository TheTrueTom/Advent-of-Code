//
//  Day03.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

final class Day03: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        lines = input.split(separator: "\n")
    }

    func part1() -> Int {
        var result1 = 0
        
        for (index, line) in lines.enumerated() {
            // FInd all the numbers
            let numbers = try! Regex("([0-9]+)")
            
            for range in line.ranges(of: numbers) {
                // Positions of the start and end of the number, with min/max to account for start/end of line and prevent out of bounds
                let nbStart = max(line.distance(from: line.startIndex, to: range.lowerBound) - 1, 0)
                let nbEnd = min(line.distance(from: line.startIndex, to: range.upperBound), line.count - 1)
                
                // Loop from the line before to the line after to find special characters, with min/max to account for start/end of file and prevent out of bounds
                for idx in max(0, index - 1)...min(index + 1, lines.count - 1) {
                    // Extend the search to the character before and the character after on each line to account for diagonals and remove all numbers and points
                    let cleanLine = String(lines[idx])[nbStart...nbEnd].trimmingCharacters(in: CharacterSet(charactersIn: "0123456789."))
                    
                    // If there is something left, it means there is a special character in range and we add the value to the sum
                    if cleanLine.count > 0 {
                        result1 += Int(line[range])!
                        break
                    }
                }
            }
        }
        
        return result1
    }

    func part2() -> Int {
        var result2 = 0
        
        for (index, line) in lines.enumerated() {
            // Find all the stars (gears)
            let gears = try! Regex("\\*")
            
            
            for gear in line.ranges(of: gears) {
                // Define the bounds of what the gear touches
                let gearScope = max(line.distance(from: line.startIndex, to: gear.lowerBound) - 1, 0)...min(line.distance(from: line.startIndex, to: gear.upperBound), line.count - 1)
                
                var gearRatio = 1
                var gearNumber = 0

                // Loop from the line before to the line after to find special characters, with min/max to account for start/end of file and prevent out of bounds
                for idx in max(0, index - 1)...min(index + 1, lines.count - 1) {
                    let consideredLine = lines[idx]
                    
                    // Regex on each line to find the numbers
                    let numbers = try! Regex("([0-9]+)")
                    
                    // For each found number, check if its range is within the scope of the gear/*
                    for range in consideredLine.ranges(of: numbers) {
                        let numberRange = consideredLine.distance(from: consideredLine.startIndex, to: range.lowerBound)...consideredLine.distance(from: consideredLine.startIndex, to: range.upperBound) - 1
                        
                        // If the range of the gear scope overlaps the range of the number, then tey are touching
                        if gearScope.overlaps(numberRange) {
                            gearRatio *= Int(consideredLine[range])!
                            gearNumber += 1
                        }
                    }
                }
                
                // If two numbers are touching the gear, we add the ratio to the result
                if gearNumber == 2 {
                    result2 += gearRatio
                }
            }
        }
        
        return result2
    }
}
