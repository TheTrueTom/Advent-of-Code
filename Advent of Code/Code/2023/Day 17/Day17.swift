//
//  Day17.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

extension String {
    public func charAt(_ offset: Int) -> String {
        let ch = self[index(startIndex, offsetBy: offset)]
        return String(ch)
    }
}

final class Day17: AOCDay {
    struct Step: Comparable {
        let cost: Int
        let pos: Point
        let dir: Direction
        let straightSteps: Int
        
        static func < (lhs: Step, rhs: Step) -> Bool {
            if lhs.cost != rhs.cost { return lhs.cost < rhs.cost }
            
            return false
        }
    }
    
    struct HashableStep: Hashable {
        let step: Step
        
        static func == (lhs: HashableStep, rhs: HashableStep) -> Bool {
            return rhs.step.pos == lhs.step.pos && rhs.step.dir == lhs.step.dir && lhs.step.straightSteps == rhs.step.straightSteps
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(step.pos)
            hasher.combine(step.dir)
            hasher.combine(step.straightSteps)
        }
    }
    
    struct SimpleStep: Hashable {
        let pos: Point
        let dir: Direction
    }
    
    private let runTest = false
    
    private var map = [Point: Int]()
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        let lines = input.split(separator: "\n")
        
        for y in 0..<lines.count {
            for x in 0..<lines[0].count {
                map[Point(x, y)] = Int(String(String(lines[y])[x]))
            }
        }
    }

    func part1() -> Int {
        return heatloss(input: map, maxStraightStep: 3)
    }

    func part2() -> Int {
        return heatloss(input: map, maxStraightStep: 10, minStraightSteps: 4)
    }
    
    func heatloss(input: [Point: Int], maxStraightStep: Int, minStraightSteps: Int = 0) -> Int {
        let maxX = input.map { $0.key.x }.max()!
        let maxY = input.map { $0.key.y }.max()!
        
        func isInside(_ pos: Point) -> Bool {
            return (0...maxX).contains(pos.x) && (0...maxY).contains(pos.y)
        }
        
        let target = Point(input.map { $0.key.x }.max()!, input.map { $0.key.x }.max()!)
        var visited: Set<HashableStep> = []
        var toVisit = PriorityQueue<Step>(ascending: true, startingValues: [Step(cost: -map[Point.zero]!, pos: Point.zero, dir: .e, straightSteps: 0), Step(cost: -map[Point.zero]!, pos: Point.zero, dir: .s, straightSteps: 0)])
        
        while let currentStep = toVisit.pop() {
            if currentStep.pos == target {
                return currentStep.cost + map[target]!
            }
            
            let id = HashableStep(step: currentStep)
            
            if !visited.insert(id).inserted { continue }
            
            for dir in Direction.cardinals {
                if currentStep.dir == dir.opposite { continue }
                
                if currentStep.dir == dir && currentStep.straightSteps == maxStraightStep { continue }
                
                if currentStep.dir != dir && currentStep.straightSteps < minStraightSteps { continue }
                
                let next = currentStep.pos.moved(direction: dir)
                
                if !isInside(next) { continue }
                
                let straightSteps = currentStep.dir == dir ? currentStep.straightSteps + 1 : 1
                
                toVisit.push(Step(cost: currentStep.cost + map[currentStep.pos]!, pos: next, dir: dir, straightSteps: straightSteps))
            }
        }
        
        fatalError("Impossible")
    }
}
