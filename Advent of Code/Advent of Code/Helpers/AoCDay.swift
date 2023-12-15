//
//  AoCDay.swift
//  Advent of Code
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

public protocol Runnable {
    static var testInput: String { get }
    static var input: String { get }
    init(input: String, testInput: String)
    func run()
}

public protocol AOCDay: Runnable {
    var day: String { get }

    associatedtype Solution1
    func part1() -> Solution1

    associatedtype Solution2
    func part2() -> Solution2
}

extension AOCDay {
    public static var testInput: String { "" }
    public static var input: String { "" }
    public var day: String { String("\(Self.self)".suffix(2)) }

    public func run() {
        run(part: 1, part1)
        run(part: 2, part2)
    }

    private func run<T>(part: Int, _ fun: () -> T) {
        let timer = Timer(day, fun: "part \(part)")
        let solution = fun()
        timer.show()
        print("Solution for day \(day) part \(part): \(solution)")
    }
}
