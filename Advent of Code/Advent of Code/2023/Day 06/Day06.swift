//
//  Day06.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

func binarySearch(totalTime: Int, targetDistance: Int) -> Int {
    func getDistance(pressedTime: Int, totalTime: Int) -> Int {
        return pressedTime * (totalTime - pressedTime)
    }
    
    var low = 0
    var high = Int(floor(Double(totalTime) / 2))
    
    if getDistance(pressedTime: high, totalTime: totalTime) < targetDistance {
        return 0
    }
    
    while low + 1 < high {
        let middle = Int(floor(Double(low + high) / 2))
        
        if getDistance(pressedTime: middle, totalTime: totalTime) >= targetDistance {
            high = middle
        } else {
            low = middle
        }
    }
    
    return totalTime - high * 2 + 1
}

final class Day06: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        self.lines = input.split(separator: "\n")
    }

    func part1() -> Int {
        let times = lines[0].split(separator: " ").compactMap { Int($0) }
        let distances = lines[1].split(separator: " ").compactMap { Int($0) }
        
        var result1 = 1
        
        for (idx, time) in times.enumerated() {
            let userDist = Array(0...time).map { $0 * (time - $0) }
            result1 *= userDist.filter { $0 > distances[idx] }.count
        }
        
        return result1
    }

    func part2() -> Int {
        let time = lines[0].replacingOccurrences(of: " ", with: "").split(separator: ":").compactMap { Int($0) }[0]
        let distance = lines[1].replacingOccurrences(of: " ", with: "").split(separator: ":").compactMap { Int($0) }[0]
        
        return binarySearch(totalTime: time, targetDistance: distance)
    }
}
