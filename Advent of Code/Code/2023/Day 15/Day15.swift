//
//  Day15.swift
//  Advent of Code
//
//  Created by Thomas Brichart on 15/12/2023.
//

import Foundation

enum Move: Character {
    case remove = "-"
    case place = "="
}

struct Lens: Hashable {
    let label: String
    let focal: Int
}

struct Instruction: Hashable {
    let label: String
    let move: Move
    let focal: Int
    
    init(input: String) {
        if input.last! == "-" {
            self.label = input.replacingOccurrences(of: "-", with: "")
            self.move = .remove
            self.focal = -1
        } else {
            self.move = .place
            self.label = String(input.split(separator: "=")[0])
            self.focal = Int(input.split(separator: "=")[1])!
        }
    }
    
    var hash: Int {
        var hash = 0
        
        for char in self.label {
            hash += Int(char.asciiValue!)
            hash *= 17
            hash = hash % 256
        }
        
        return hash
    }
}

final class Day15: AOCDay {
    private let runTest = false
    private let instructions: String
    private var boxes = [[(String, Int)]](repeating: [(String, Int)](), count: 256)
    
    func calculateHash(_ input: String) -> Int {
        var hash = 0
        
        for char in input {
            hash += Int(char.asciiValue!)
            hash *= 17
            hash = hash % 256
        }
        
        return hash
    }
    
    func focusingPower(_ boxes: [[(String, Int)]]) -> Int {
        var focus = 0
        
        for (idx, box) in boxes.enumerated() {
            for (place, lens) in box.enumerated() {
                focus += (idx + 1) * (place + 1) * lens.1
            }
        }
        
        return focus
    }
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        instructions = input
    }

    func part1() -> Int {
        let hashes = instructions.split(separator: ",").compactMap { calculateHash(String($0)) }
        
        return hashes.sum
    }

    func part2() -> Int {
        let instructions = instructions.split(separator: ",").compactMap { Instruction(input: String($0)) }
        
        for instruction in instructions {
            let box = instruction.hash
            let move = instruction.move
            
            if move == .remove {
                if let idx = boxes[box].firstIndex(where: { $0.0 == (instruction.label)}) {
                    boxes[box].remove(at: idx)
                }
            } else {
                if let idx = boxes[box].firstIndex(where: { $0.0 == (instruction.label)}) {
                    boxes[box][idx] = (instruction.label, instruction.focal)
                } else {
                    boxes[box].append((instruction.label, instruction.focal))
                }
            }
        }
        
        return focusingPower(boxes)
    }
}
