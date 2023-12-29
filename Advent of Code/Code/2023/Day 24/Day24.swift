//
//  Day24.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

private typealias Vector = D3Point

private extension Vector {
    func moveWithVelocity(_ speed: D3Point, for time: Int) -> D3Point {
        return Vector(self.x + speed.x * time, self.y + speed.y * time, self.z + speed.z * time)
    }
}

private struct Hail {
    let position: D3Point
    let velocity: Vector
    
    init(from string: String) {
        let elts = string.split(separator: " @ ").map { $0.replacingOccurrences(of: " ", with: "").split(separator: ",").compactMap { Int($0) } }
        
        position = D3Point(elts[0][0], elts[0][1], elts[0][2])
        velocity = Vector(elts[1][0], elts[1][1], elts[1][2])
    }
    
    init(position: D3Point, velocity: Vector) {
        self.position = position
        self.velocity = velocity
    }
    
    func intersectsWith(_ hail2: Hail) -> Point? {
        let determinant = self.velocity.x * hail2.velocity.y - hail2.velocity.x * self.velocity.y
        
        guard determinant != 0 else { return nil } // Hails don't collide
        
        let b0 = self.velocity.x * self.position.y - self.velocity.y * self.position.x
        let b1 = hail2.velocity.x * hail2.position.y - hail2.velocity.y * hail2.position.x
        
        let x = hail2.velocity.x * (b0 / determinant / 1000) - self.velocity.x * (b1 / determinant / 1000)
        let y = hail2.velocity.y * (b0 / determinant / 1000) - self.velocity.y * (b1 / determinant / 1000)
        
        return Point(x * 1000, y * 1000)
    }
    
    func isInFuture(_ point: D3Point) -> Bool {
        if velocity.x != 0 {
            return (velocity.x < 0) ? point.x < position.x : point.x > position.x
        }
        
        if velocity.y != 0 {
            return (velocity.y < 0) ? point.y < position.y : point.y > position.y
        }
        
        if velocity.z != 0 {
            return (velocity.x < 0) ? point.z < position.z : point.z > position.z
        }
        
        return true
    }
}

final class Day24: AOCDay {
    private let runTest = false
    private let hails: [Hail]
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        let lines = input.split(separator: "\n")
        
        hails = lines.map {
            Hail(from: String($0))
        }
    }

    func part1() -> Int {
        // let range = 7...27
        let range = 200000000000000...400000000000000
        
        var count = 0
        
        for i in 0..<hails.count {
            for j in i+1..<hails.count {
                if let intersection = hails[i].intersectsWith(hails[j]) {
                    let D3Intersection = D3Point(intersection.x, intersection.y, 0)
                    if range.contains(intersection.x) && range.contains(intersection.y) && hails[i].isInFuture(D3Intersection) && hails[j].isInFuture(D3Intersection) {
                        count += 1
                    }
                }
            }
        }
        
        return count
    }
    
    func part2() -> Int {
        return 0
    }
}
