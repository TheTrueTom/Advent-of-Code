//
//  main.swift
//  2023.2
//
//  Created by Thomas Brichart on 16/11/2023.
//

import Foundation

func main() throws {
    let input = try readInput(fromTestFile: false).split(separator: "\n")
    
    var result1 = 0
    
    for (index, line) in input.enumerated() {
        // FInd all the numbers
        let numbers = try Regex("([0-9]+)")
        
        for range in line.ranges(of: numbers) {
            // Positions of the start and end of the number, with min/max to account for start/end of line and prevent out of bounds
            let nbStart = max(line.distance(from: line.startIndex, to: range.lowerBound) - 1, 0)
            let nbEnd = min(line.distance(from: line.startIndex, to: range.upperBound), line.count - 1)
            
            // Loop from the line before to the line after to find special characters, with min/max to account for start/end of file and prevent out of bounds
            for idx in max(0, index - 1)...min(index + 1, input.count - 1) {
                // Extend the search to the character before and the character after on each line to account for diagonals and remove all numbers and points
                let cleanLine = String(input[idx])[nbStart...nbEnd].trimmingCharacters(in: CharacterSet(charactersIn: "0123456789."))
                
                // If there is something left, it means there is a special character in range and we add the value to the sum
                if cleanLine.count > 0 {
                    result1 += Int(line[range])!
                    break
                }
            }
        }
    }
    
    print("Part1: \(result1)")
    
    var result2 = 0
    
    for (index, line) in input.enumerated() {
        // Find all the stars (gears)
        let gears = try Regex("\\*")
        
        
        for gear in line.ranges(of: gears) {
            // Define the bounds of what the gear touches
            let gearScope = max(line.distance(from: line.startIndex, to: gear.lowerBound) - 1, 0)...min(line.distance(from: line.startIndex, to: gear.upperBound), line.count - 1)
            
            var gearRatio = 1
            var gearNumber = 0

            // Loop from the line before to the line after to find special characters, with min/max to account for start/end of file and prevent out of bounds
            for idx in max(0, index - 1)...min(index + 1, input.count - 1) {
                let consideredLine = input[idx]
                
                // Regex on each line to find the numbers
                let numbers = try Regex("([0-9]+)")
                
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
    
    print("Part2: \(result2)")
}

Timer.time(main)

