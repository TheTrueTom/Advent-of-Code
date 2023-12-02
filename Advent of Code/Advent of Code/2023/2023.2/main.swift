//
//  main.swift
//  2023.2
//
//  Created by Thomas Brichart on 16/11/2023.
//

import Foundation

func main() throws {
    let games = try readInput(fromTestFile: false).split(separator: "\n")
    
    let maxValue = ["red": 12, "green": 13, "blue": 14]
    
    var impossibleGameIDs: Set<Int> = []
    var gameIDsum = 0
    var powers: [Int] = []
    
    for game  in games {
        let gameInfo = game.split(separator: ": ")
        
        let gameID = Int(gameInfo[0].replacingOccurrences(of: "Game ", with: "").replacingOccurrences(of: ": ", with: ""))!
        gameIDsum += gameID
        let gameElements = gameInfo[1].split(separator: "; ")
        
        var minNeededValues = ["red": 0, "green": 0, "blue": 0]
        
        for gameElement in gameElements {
            let elements = gameElement.split(separator: ", ")
            
            for element in elements {
                let elementDetails = element.split(separator: " ")
                
                let number = Int(elementDetails[0])!
                let color = String(elementDetails[1])
                let maxValueForColor = maxValue[color]!
                
                if number > maxValueForColor {
                    impossibleGameIDs.insert(gameID)
                }
                
                if number > minNeededValues[color]! {
                    minNeededValues[color] = number
                }
            }
        }
        
        powers.append(minNeededValues["red"]! * minNeededValues["green"]! * minNeededValues["blue"]!)
    }
    
    let result1 = gameIDsum - impossibleGameIDs.reduce(0, +)
    
    print("Part1: \(result1)")
    
    let result2 = powers.reduce(0, +)
    
    print("Part2: \(result2)")
}

Timer.time(main)

