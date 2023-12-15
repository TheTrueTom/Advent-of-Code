//
//  Day08.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

struct Node {
    let origin: String
    let destination: (l: String, r: String)
}

func gcd(_ a: Int, _ b: Int) -> Int {
    let remainder = abs(a) % abs(b)
    if remainder != 0 {
        return gcd(abs(b), remainder)
    } else {
        return abs(b)
    }
}

final class Day08: AOCDay {
    private let runTest = false
    private let blocks: [String.SubSequence]
    
    let pattern: String.SubSequence
    let map: [Node]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        self.blocks = input.split(separator: "\n\n")
        
        self.pattern = blocks[0]
        
        self.map = blocks[1].split(separator: "\n").compactMap { input in
            let parts = input.split(separator: " = ")
            let subParts = parts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").split(separator: ", ").map { String($0) }
            return Node(origin: String(parts[0]), destination: (l: subParts[0], r: subParts[1]))
        }
    }

    func part1() -> Int {
        var result1 = 0
        var currentNode = "AAA"
        
        while currentNode != "ZZZ" {
            for elt in pattern {
                let nextNode = map.first(where: { $0.origin == currentNode})!
                currentNode = elt == "L" ? nextNode.destination.l : nextNode.destination.r
                result1 += 1
            }
        }
        
        return result1
    }

    func part2() -> Int {
        let startNodes = map.filter { $0.origin.last! == "A" }.compactMap { $0.origin }
        var distanceToZZZ = [Int]()
        
        for node in startNodes {
            var length = 0
            var currentNode = node
            
            while currentNode.last! != "Z" {
                for elt in pattern {
                    let nextNode = map.first(where: { $0.origin == currentNode})!
                    currentNode = elt == "L" ? nextNode.destination.l : nextNode.destination.r
                    length += 1
                }
            }
            
            distanceToZZZ.append(length)
        }
        
        let result2 = distanceToZZZ.reduce(distanceToZZZ[0], { x, y in x * y / gcd(x, y) })
        
        return result2
    }
}
