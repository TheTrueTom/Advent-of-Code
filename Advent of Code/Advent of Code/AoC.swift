//
//  main.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

@main
struct AdventOfCode {
    static let dayToRun = 2
    
    static func main() {
        let day = days[dayToRun - 1]
        day.init(input: day.input, testInput: day.testInput).run()
        Timer.showTotal()
    }

    private static let days: [Runnable.Type] = [
        Day01.self, Day15.self
    ]
}
