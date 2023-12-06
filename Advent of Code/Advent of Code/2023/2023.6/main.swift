//
//  main.swift
//  2023.6
//
//  Created by Thomas Brichart on 06/12/2023.
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

func main() throws {
    let input = try readInput(fromTestFile: false).split(separator: "\n")
    
    let times = input[0].split(separator: " ").compactMap { Int($0) }
    let distances = input[1].split(separator: " ").compactMap { Int($0) }
    
    var result1 = 1
    
    for (idx, time) in times.enumerated() {
        let userDist = Array(0...time).map { $0 * (time - $0) }
        result1 *= userDist.filter { $0 > distances[idx] }.count
    }
    
    print("Part1: \(result1)")
    
    let time = input[0].replacingOccurrences(of: " ", with: "").split(separator: ":").compactMap { Int($0) }[0]
    let distance = input[1].replacingOccurrences(of: " ", with: "").split(separator: ":").compactMap { Int($0) }[0]
    
    // Brute-force method
    //let userDist = Array(0...time).map { $0 * (time - $0) }
    //result2 = userDist.filter { $0 > distance }.count
    
    // Pretty method
    let result2 = binarySearch(totalTime: time, targetDistance: distance)
    
    print("Part2: \(result2)")
}

Timer.time(main)

