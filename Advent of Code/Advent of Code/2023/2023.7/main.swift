//
//  main.swift
//  2023.7
//
//  Created by Thomas Brichart on 07/12/2023.
//

import Foundation

func lhsBiggerCard(lhs: String, rhs: String, partTwo: Bool = false) -> Bool {
    let cardOrder = partTwo ? ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"] : ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
    
    guard cardOrder.contains(lhs) && cardOrder.contains(rhs) else { return false }
    
    return cardOrder.firstIndex(of: lhs)! < cardOrder.firstIndex(of: rhs)!
}

func lhsBiggerHand(lhs: [String], rhs: [String], partTwo: Bool = false) -> Bool {
    let lhsClean = partTwo ? Set(lhs.filter { $0 != "J" }) : Set(lhs)
    let rhsClean = partTwo ? Set(rhs.filter { $0 != "J" }) : Set(rhs)
    
    let lhsCleanClean = lhsClean == [] ? ["A", "A", "A", "A", "A"] : lhsClean
    let rhsCleanClean = rhsClean == [] ? ["A", "A", "A", "A", "A"] : rhsClean
    
    var lhsCounts = Array(lhsCleanClean.map { elt in lhs.filter { stuff in elt == stuff }.count }.sorted().reversed())
    var rhsCounts = Array(rhsCleanClean.map { elt in rhs.filter { stuff in elt == stuff }.count }.sorted().reversed())
    
    if partTwo {
        lhsCounts[0] += lhs.filter { $0 == "J" }.count
        rhsCounts[0] += rhs.filter { $0 == "J" }.count
    }
    
    if lhsCounts == rhsCounts {
        for i in 0...lhs.count - 1 {
            if lhs[i] == rhs[i] {
                continue
            } else if lhsBiggerCard(lhs: lhs[i], rhs: rhs[i], partTwo: partTwo) {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    for i in 0...4 {
        if lhsCounts[i] > rhsCounts[i] {
            return true
        } else if lhsCounts[i] < rhsCounts[i] {
            return false
        }
    }
    
    return false
}

func main() throws {
    let input = try readInput(fromTestFile: false).split(separator: "\n")
    
    let cards = Array(input.map { ($0.split(separator: " ")[0].split(separator: "").map { String($0) }, Int($0.split(separator: " ")[1])!) }.sorted { lhsBiggerHand(lhs: $0.0, rhs: $1.0) }.reversed())
    
    var result1 = 0
    
    for (idx, card) in cards.enumerated() {
        result1 += card.1 * (idx + 1)
    }
    
    print("Part1: \(result1)")
    
    let cardsTwo = Array(input.map { ($0.split(separator: " ")[0].split(separator: "").map { String($0) }, Int($0.split(separator: " ")[1])!) }.sorted { lhsBiggerHand(lhs: $0.0, rhs: $1.0, partTwo: true) }.reversed())
    
    var result2 = 0
    
    for (idx, card) in cardsTwo.enumerated() {
        result2 += card.1 * (idx + 1)
    }
    
    print("Part2: \(result2)")
}

Timer.time(main)

