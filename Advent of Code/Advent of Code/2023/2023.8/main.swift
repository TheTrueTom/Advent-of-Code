//
//  main.swift
//  2023.8
//
//  Created by Thomas Brichart on 08/12/2023.
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

func main() throws {
    let input = try readInput(fromTestFile: false).split(separator: "\n\n")
    
    let pattern = input[0]
    
    let map = input[1].split(separator: "\n").compactMap { input in
        let parts = input.split(separator: " = ")
        let subParts = parts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").split(separator: ", ").map { String($0) }
        return Node(origin: String(parts[0]), destination: (l: subParts[0], r: subParts[1]))
    }
    
    var result1 = 0
    var currentNode = "AAA"
    
    while currentNode != "ZZZ" {
        for elt in pattern {
            let nextNode = map.first(where: { $0.origin == currentNode})!
            currentNode = elt == "L" ? nextNode.destination.l : nextNode.destination.r
            result1 += 1
        }
    }
    
    print("Part1: \(result1)")
    
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
    
    print("Part2: \(result2)")
}

Timer.time(main)
