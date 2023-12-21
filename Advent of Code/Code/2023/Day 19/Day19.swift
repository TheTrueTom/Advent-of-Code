//
//  Day19.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

final class Day19: AOCDay {
    struct Part {
        let x, m, a, s: Int
        
        init(from string: String) {
            let pattern = /{x=(\d+),m=(\d+),a=(\d+),s=(\d+)}/
            
            if let match = try? pattern.wholeMatch(in: string) {
                x = Int(match.1)!
                m = Int(match.2)!
                a = Int(match.3)!
                s = Int(match.4)!
            } else {
                fatalError("Incorrect string")
            }
        }
        
        var factorsSum: Int {
            x + m + a + s
        }
    }
    
    struct PartRange {
        let worflow: String
        let ranges: [String: ClosedRange<Int>]
    }
    
    struct Rule {
        static let greater:(Int, Int) -> Bool = (>)
        static let lesser: (Int, Int) -> Bool = (<)
        
        let source: String?
        let comparator: ((Int, Int) -> Bool)?
        let value: Int?
        let target: String
        
        init(from string: String) {
            let elts = string.split(separator: ":")
            
            if elts.count == 1 {
                source = nil
                comparator = nil
                value = nil
                target = String(elts[0])
            } else {
                let pattern = /(\w+)(<|>)(\d+)/
                
                if let match = try? pattern.firstMatch(in: elts[0]) {
                    source = String(match.1)
                    comparator = match.2 == ">" ? Day19.Rule.greater : Day19.Rule.lesser
                    value = Int(match.3)
                } else {
                    source = nil
                    comparator = nil
                    value = nil
                }
                
                target = String(elts[1])
            }
        }
        
        var isAccepted: Bool {
            return target == "A"
        }
        
        var isRejected: Bool {
            return target == "R"
        }
        
        var isDestination: Bool {
            return !isAccepted && !isRejected
        }
        
        var hasNoCondition: Bool {
            return source == nil && comparator == nil && value == nil
        }
        
        func isRespected(by part: Part) -> Bool {
            guard let source = self.source, let comparator = self.comparator, let value = self.value else { return true }
            
            let lhs = source == "a" ? part.a : source == "s" ? part.s : source == "m" ? part.m : part.x
            
            return comparator(lhs, value)
        }
        
        func splittingRange(_ range: ClosedRange<Int>) -> (a: ClosedRange<Int>, r: ClosedRange<Int>) {
            guard let _ = self.source, let comparator = self.comparator, let value = self.value else {
                return isRejected ? (a: 0...0, r: range) : (a: range, r: 0...0)
            }
            
            if comparator(1,0) { // >
                return (a: value + 1...range.upperBound, r: range.lowerBound...value)
            } else { // <
                return (a: range.lowerBound...value - 1, r: value...range.upperBound)
            }
        }
    }
    
    struct Worflow {
        let value: String
        let rules: [Rule]
        
        init(from string: String) {
            let pattern = /(\w+){(.+)}/
            var rules = [Rule]()
            
            if let match = try? pattern.firstMatch(in: string) {
                value = String(match.1)
                
                for ruleString in String(match.2).split(separator: ",") {
                    rules.append(Rule(from: String(ruleString)))
                }
                
                self.rules = rules
            } else {
                fatalError("Incorrect string")
            }
        }
    }
    
    private let runTest = false
    private let workflows: [Worflow]
    private let parts: [Part]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        workflows = input.split(separator: "\n\n")[0].split(separator: "\n").map { Worflow(from: String($0)) }
        parts = input.split(separator: "\n\n")[1].split(separator: "\n").map { Part(from: String($0)) }
    }
    
    func testPart(_ part: Part) -> Bool {
        var workflow = "in"
        
        while true {
            guard let current = workflows.first(where: { $0.value == workflow }) else { fatalError("Impossible") }
            
            for rule in current.rules {
                if rule.isRespected(by: part) {
                    if rule.isDestination {
                        workflow = rule.target
                        break
                    } else {
                        return rule.isAccepted
                    }
                }
            }
            
        }
    }

    func part1() -> Int {
        let result = parts.map { testPart($0) ? $0.factorsSum : 0 }.sum
        
        return result
    }

    func part2() -> Int {
        let start = PartRange(worflow: "in", ranges: ["a": 1...4000, "m": 1...4000, "s": 1...4000, "x": 1...4000])
        
        var rangesToTest = [start]
        var winningRanges = [PartRange]()
        
        while !rangesToTest.isEmpty {
            var currentRange = rangesToTest.removeLast()
            
            guard let currentWorflow = workflows.first(where: { $0.value == currentRange.worflow }) else { fatalError("Impossible") }
            
            for rule in currentWorflow.rules {
                if rule.hasNoCondition && rule.isAccepted {
                    winningRanges.append(currentRange)
                    break
                }
                
                if rule.hasNoCondition && rule.isRejected {
                    break
                }
                
                if rule.hasNoCondition && rule.isDestination {
                    rangesToTest.append(PartRange(worflow: rule.target, ranges: currentRange.ranges))
                    break
                }
                
                if let source = rule.source {
                    let split = rule.splittingRange(currentRange.ranges[source]!)
                    
                    var accepted = currentRange.ranges
                    accepted[source] = split.a
                    
                    if rule.isAccepted {
                        winningRanges.append(PartRange(worflow: rule.target, ranges: accepted))
                    } else if rule.isDestination {
                        rangesToTest.append(PartRange(worflow: rule.target, ranges: accepted))
                    }
                    
                    var rejected = currentRange.ranges
                    rejected[source] = split.r
                    currentRange = PartRange(worflow: currentRange.worflow, ranges: rejected)
                    
                }
            }
        }
        
        let result = winningRanges.map { $0.ranges.map { $0.value.upperBound - $0.value.lowerBound + 1 }.reduce(1, *) }.sum
        
        return result
    }
}
