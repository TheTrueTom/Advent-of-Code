//
//  main.swift
//  2023.5
//
//  Created by Thomas Brichart on 04/12/2023.
//

import Foundation

// Model

struct Map {
    let from: String
    let to: String
    let rangeMaps: [RangeMap]
}

struct RangeMap {
    let sourceRange: Range<Int>
    let destination: Int
    
    init(source: Int, destination: Int, length: Int) {
        self.sourceRange = source..<source+length
        self.destination = destination
    }
    
    subscript(source: Int) -> Int {
        assert(sourceRange.contains(source))
        
        return destination + source - sourceRange.lowerBound
    }
}

func getNextStep(maps: [Map], value: Int, step: String, remaining: Int = Int.max) -> (value: Int, step: String, remaining: Int) {
    let rangeMaps = maps.filter { $0.from == step }.compactMap { $0.rangeMaps }[0]
    
    var exitValue = value
    var remaining = remaining
    
    for rangeMap in rangeMaps {
        if rangeMap.sourceRange.contains(value) {
            exitValue = rangeMap[value]
            
            if rangeMap.sourceRange.upperBound - value < remaining {
                remaining = rangeMap.sourceRange.upperBound - value
            }
            
            break
        }
    }
    
    let destination = maps.filter { $0.from == step }.first!.to
    
    return (value: exitValue, step: destination, remaining: remaining)
}

func main() throws {
    
    let input = try readInput(fromTestFile: false)
    
    var seeds = [Int]()
    var maps = [Map]()
    
    for (idx, group) in input.split(separator: "\n\n").enumerated() {
        if idx == 0 {
            seeds = group.split(separator: " ").compactMap { Int($0) }
        } else {
            let elts = group.split(separator: "\n")
            let from = String(elts[0].dropLast().split(separator: "-to-")[0])
            let to = elts[0].split(separator: "-to-")[1].replacingOccurrences(of: " map:", with: "")
            
            let rangeMaps = elts[1...].map {
                let mapNum = $0.split(separator: " ").compactMap { Int($0) }
                return RangeMap(source: mapNum[1], destination: mapNum[0], length: mapNum[2])
            }
            
            maps.append(Map(from: from, to: to, rangeMaps: rangeMaps))
        }
    }
    
    var result1 = [Int]()
    
    for seed in seeds {
        var step = "seed"
        var value = seed
        
        while step != "location" {
            let res = getNextStep(maps: maps, value: value, step: step)
            step = res.step
            value = res.value
        }
        
        result1.append(value)
    }
    
    print("Part1: \(result1.min()!)")
    
    var result2 = [Int]()
    
    for i in stride(from: 0, to: seeds.count - 1, by: 2) {
        var j = 0
        
        while seeds[i] + j < seeds[i] + seeds[i+1] {
            var step = "seed"
            var value = seeds[i] + j
            var remaining = Int.max
            
            while step != "location" {
                let res = getNextStep(maps: maps, value: value, step: step, remaining: remaining)
                step = res.step
                value = res.value
                remaining = res.remaining
            }
            
            result2.append(value)
            
            j += remaining
        }
    }
    
    print("Part2: \(result2.min()!)")
}

Timer.time(main)
