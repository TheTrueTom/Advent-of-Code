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
    var copiesDic = [Int: Int]()
    
    var result1 = 0
    
    for line in input {
        var cardNumber = Int(line.split(separator: ":")[0].replacingOccurrences(of: "Card", with: "").replacingOccurrences(of: " ", with: ""))!
        let winningNumbers = Set(line.split(separator: ":")[1].split(separator: "|")[0].split(separator: " ").compactMap { Int($0)! })
        let userNumbers = Set(line.split(separator: ":")[1].split(separator: "|")[1].split(separator: " ").compactMap { Int($0)! })
        
        let commonNumbers = winningNumbers.intersection(userNumbers)
        result1 += 1 << (commonNumbers.count - 1)
        
        resDic[cardNumber] = commonNumbers.count
    }
    
    print("Part1: \(result1)")
    
    for i in 1...resDic.keys.count {
        copiesDic[i] = 1
    }
    
    for i in 1...copiesDic.keys.count {
        
        // If we need to add card copies
        if resDic[i]! > 0 {
            
            // For each card copy
            for _ in 1...copiesDic[i]! {
                
                // We add the number of following cards
                for j in 1...resDic[i]! {
                    if i + j <= resDic.keys.max()! {
                        copiesDic[i + j] = copiesDic[i + j]! + 1
                    }
                }
            }
        }
    }
    
    let result2 = copiesDic.values.reduce(0, +)
    print("Part2: \(result2)")
}

Timer.time(main)



