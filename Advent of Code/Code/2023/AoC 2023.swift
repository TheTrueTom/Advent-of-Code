//
//  main.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

@main
struct AdventOfCode2023 {
    static let dayToRun = 15
    
    static func main() {
        let day = days[dayToRun - 1]
        day.init(input: day.input, testInput: day.testInput).run()
        Timer.showTotal()
    }

    private static let days: [Runnable.Type] = [
        Day01.self, Day02.self, Day03.self, Day04.self,
        Day05.self, Day06.self, Day07.self, Day08.self,
        Day09.self, Day10.self, Day11.self, Day12.self,
        Day13.self, Day14.self, Day15.self, Day16.self,
        Day17.self, Day18.self, Day19.self, Day20.self,
        Day21.self, Day22.self, Day23.self, Day24.self,
        Day25.self
    ]
}
