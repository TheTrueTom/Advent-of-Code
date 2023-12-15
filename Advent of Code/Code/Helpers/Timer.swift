//
//  Timer.swift
//  Advent of Code
//
//  Created by Thomas Brichart on 16/11/2023.
//

import Foundation

public final class Timer {
    private let start = Date().timeIntervalSinceReferenceDate
    private let name: String

    private static var total: TimeInterval = 0
    private static let formatter: NumberFormatter = {
        let fmt = NumberFormatter()
        fmt.maximumFractionDigits = 3
        fmt.locale = Locale(identifier: "en_US")
        return fmt
    }()

    public init(_ day: String, fun: String = #function) {
        self.name = "Day \(day) \(fun)"
    }

    public static func time<Result>(_ day: String, name: String = "parse", closure: () -> Result) -> Result {
        let timer = Timer(day, fun: name)
        defer { timer.show() }
        return closure()
    }

    public func show() {
        let elapsed = Date().timeIntervalSinceReferenceDate - start
        Self.total += elapsed
        print("\(name) took \(Self.formatted(elapsed))")
    }

    public static func showTotal() {
        print("Total time: \(formatted(Self.total))")
    }

    private static func formatted(_ interval: TimeInterval) -> String {
        return "\(formatter.string(for: interval * 1_000)!) ms"
    }
}
