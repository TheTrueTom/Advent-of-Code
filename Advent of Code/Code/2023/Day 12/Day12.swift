//
//  Day12.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

class Springs {
    let springs: [String.Element]
    let damaged: [Int]
    var memory: [State: Int] = [:]

    struct State: Hashable {
        let springIdx: Int
        let damagedIdx: Int
        let groupSize: Int

        func nextSpring() -> State {
            State(springIdx: springIdx + 1, damagedIdx: damagedIdx, groupSize: 0)
        }

        func nextSpringAndDamaged() -> State {
            State(springIdx: springIdx + 1, damagedIdx: damagedIdx + 1, groupSize: 0)
        }

        func nextSpringAndGroup() -> State {
            State(springIdx: springIdx + 1, damagedIdx: damagedIdx, groupSize: groupSize + 1)
        }
    }

    init(_ line: String, _ multiplied: Bool = false) {
        var elements = line.components(separatedBy: " ")
        if multiplied {
            let copySpring = elements[0]
            let copyDamaged = elements[1]
            for _ in 1..<5 {
                elements[0] += "?" + copySpring
                elements[1] += "," + copyDamaged
            }
        }
        self.springs = elements[0].map { $0 }
        self.damaged = elements[1].components(separatedBy: ",").map { Int($0)! }
    }

    func arrangements(_ state: State = State(springIdx: 0, damagedIdx: 0, groupSize: 0)) -> Int
    {
        if memory.keys.contains(state) {
            return memory[state]!
        }

        let springIdx = state.springIdx
        let damagedIdx = state.damagedIdx
        let groupSize = state.groupSize

        if springs.count == springIdx {
            if damaged.count == damagedIdx && groupSize == 0 {
                return 1
            }
            else if damaged.count - 1 == damagedIdx && damaged[damagedIdx] == groupSize {
                return 1
            }
            else {
                return 0
            }
        }

        var possibilites = 0

        for char in [".", "#"].map({ $0.first }) {
            if springs[springIdx] == char || springs[springIdx] == "?" {
                if char == "." && groupSize == 0 {
                    possibilites += arrangements(state.nextSpring())
                }
                else if char == "." && groupSize > 0 && damagedIdx < damaged.count
                    && damaged[damagedIdx] == groupSize
                {
                    possibilites += arrangements(state.nextSpringAndDamaged())
                }
                else if char == "#" {
                    possibilites += arrangements(state.nextSpringAndGroup())
                }
            }
        }

        memory[state] = possibilites
        return possibilites
    }
}

final class Day12: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        self.lines = input.split(separator: "\n")
    }

    func part1() -> Int {
        return lines.map { Springs(String($0)).arrangements() }.sum
    }

    func part2() -> Int {
        return lines.map { Springs(String($0), true).arrangements() }.sum
    }
}
