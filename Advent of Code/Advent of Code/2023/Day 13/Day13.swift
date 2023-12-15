//
//  Day13.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

func findMirroringPoint(_ pattern: String, withExisting existing: (Int, String)? = nil) -> (Int, String)? {
    func hasOneDiff(_ a: String, _ b: String) -> Bool {
        var hasDiff = false
        
        for i in 0..<a.count {
            if a[i] != b[i] {
                if hasDiff { return false }
                else { hasDiff = true}
            }
        }
        
        return true
    }
    
    func transposeArray(_ array: String) -> String {
        let lines = array.split(separator: "\n").compactMap { $0.split(separator: "") }
        
        var newArray = [String]()
        for i in 0..<lines[0].count {
            var string = ""
            for line in lines {
                string += line[i]
            }
            newArray.append(string)
        }
        
        return newArray.joined(separator: "\n")
    }
    func mirrorIndex(_ thePattern: String, smudgeReference: Int? = nil) -> Int? {
        let lines = thePattern.split(separator: "\n").compactMap { String($0) }
        
        // We look between the second and before last lines
        lineLoop: for i in 0..<lines.count - 1 {
            if let ref = smudgeReference, i == ref {
                continue lineLoop
            }
            
            let linesBefore = i
            let linesAfter = lines.count - i - 1
            
            var alreadySmudged = false
            
            mirrorLoop: for j in 0...min(linesBefore, linesAfter - 1) {
                if lines[i - j] != lines[i + j + 1] {
                    if smudgeReference == nil || alreadySmudged || !hasOneDiff(lines[i - j], lines[i + j + 1]) {
                        continue lineLoop
                    } else if hasOneDiff(lines[i - j], lines[i + j + 1]) && !alreadySmudged {
                        alreadySmudged = true
                    }
                }
            }
            
            return i
        }
        
        return nil
    }
    if let existing = existing {
        if let horizontal = mirrorIndex(pattern, smudgeReference: (existing.1 == "h") ? existing.0 - 1 : -1) {
            return (horizontal + 1, "h")
        }
        
        let transposed = transposeArray(pattern)
        if let vertical = mirrorIndex(transposed, smudgeReference: (existing.1 == "v") ? existing.0 - 1 : -1) {
            return (vertical + 1, "v")
        }
    } else {
        if let horizontal = mirrorIndex(pattern) {
            return (horizontal + 1, "h")
        }
        
        let transposed = transposeArray(pattern)
        if let vertical = mirrorIndex(transposed) {
            return (vertical + 1, "v")
        }
    }
    
    return nil
}

final class Day13: AOCDay {
    private let runTest = false
    private let patterns: [String]
    
    var existing: [(Int, String)]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        patterns = input.split(separator: "\n\n").compactMap { String($0) }
        existing = [(Int, String)]()
    }

    func part1() -> Int {
        var result1 = 0
        
        for pattern in patterns {
            if let result = findMirroringPoint(pattern) {
                existing.append(result)
                result1 += (result.1 == "h") ? result.0 * 100 : result.0
            }
        }
        
        return result1
    }

    func part2() -> Int {
        var result2 = 0
        for i in 0..<patterns.count {
            if let result = findMirroringPoint(patterns[i], withExisting: existing[i]) {
                result2 += (result.1 == "h") ? result.0 * 100 : result.0
            }
        }
        
        return result2
    }
}
