//
//  Day02.swift
//  AoC
//
//  Created by Thomas Brichart on 15/12/2023.
//

import Foundation

final class Day02: AOCDay {
    private let runTest = false
    
    private let games: [String.SubSequence]
    
    private let maxValue = ["red": 12, "green": 13, "blue": 14]
    
    private var impossibleGameIDs: Set<Int> = []
    private var gameIDsum = 0
    private var powers: [Int] = []
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        games = input.split(separator: "\n")
    }

    func part1() -> Int {
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
                    let maxValueForColor = self.maxValue[color]!
                    
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
        
        return gameIDsum - impossibleGameIDs.sum
    }

    func part2() -> Int {
        return powers.sum
    }
}

