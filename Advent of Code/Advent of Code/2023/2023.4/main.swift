//
//  main.swift
//  2023.4
//
//  Created by Thomas Brichart on 04/12/2023.
//

import Foundation

func main() throws {
    let input = try readInput(fromTestFile: false).split(separator: "\n")
    
    var resDic = [Int: Int]()
    
    var result1 = 0
    
    for line in input {
        let cardNumber = Int(line.split(separator: ":")[0].replacingOccurrences(of: "Card", with: "").replacingOccurrences(of: " ", with: ""))!
        let winningNumbers = Set(line.split(separator: ":")[1].split(separator: "|")[0].split(separator: " ").compactMap { Int($0)! })
        let userNumbers = Set(line.split(separator: ":")[1].split(separator: "|")[1].split(separator: " ").compactMap { Int($0)! })
        
        let commonNumbers = winningNumbers.intersection(userNumbers)
        result1 += 1 << (commonNumbers.count - 1)
        
        resDic[cardNumber] = commonNumbers.count
    }
    
    print("Part1: \(result1)")
    
    var copies = [Int](repeating: 1, count: input.count)
    
    // Loop over the cards
    for i in 0...input.count-1 {
        // If we have to add cards
        if resDic[i+1]! > 0 {
            // Add cards along the following numbers
            for j in i+1...i+resDic[i+1]! {
                // Add every time the number of cards needed (being the number of cards of the current considered card)
                copies[j] += copies[i]
            }
        }
    }
    
    let result2 = copies.reduce(0, +)
    print("Part2: \(result2)")
}

Timer.time(main)



