//
//  Day20.swift
//  AoC
//
//  Created by Thomas Brichart on 14/12/2023.
//

import Foundation

private enum ModuleType: Character {
    case flipFlop = "%"
    case conjunction = "&"
    case broadcaster = "b"
}

private enum Pulse {
    case high, low
}

private class Module: CustomStringConvertible {
    let name: String
    var destinations: [String]
    let type: ModuleType
    var state: Bool = false
    var connectedInputs = [String: Pulse]()
    var sentHigh = false
    
    init(from string: String) {
        let pattern = /(.+) -> (.+)/
        
        if let match = try? pattern.firstMatch(in: string) {
            var stringMatch = String(match.1)
            
            if stringMatch == "broadcaster" {
                type = .broadcaster
                name = stringMatch
            } else {
                type = ModuleType(rawValue: stringMatch.removeFirst())!
                name = stringMatch
            }
            
            destinations = match.2.split(separator: ", ").map { String($0) }
        } else {
            fatalError("Impossible")
        }
    }
    
    func receivePulse(_ pulse: Pulse, from module: String) {
        connectedInputs[module] = pulse
        
        if type == .flipFlop && pulse == .low { state.toggle() }
    }
    
    func sendPulse(_ pulse: Pulse, from module: String) -> Pulse? {
        switch type {
        case .flipFlop:
            if pulse == .high {
                return nil
            } else {
                return state == true ? .high : .low
            }
        case .conjunction:
            let allHigh = connectedInputs.allSatisfy { $0.value == .high }
            sentHigh = !allHigh
            return allHigh ? .low : .high
        case .broadcaster:
            return .low
        }
    }
    
    var description: String {
        return "\(name) - type: \(type) - connectedTo: \(destinations) - state: \(state)"
    }
}

final class Day20: AOCDay {
    private let runTest = false
    private let lines: [String.SubSequence]
    
    private var modules = [Module]()
    
    init(input: String, testInput: String) {
        let input = runTest ? testInput : input
        lines = input.split(separator: "\n")
    }
    
    private func setupModules() {
        modules = lines.map { Module(from: String($0)) }
        
        for module in modules {
            if module.type == .conjunction {
                let inputs = modules.filter { $0.destinations.contains(module.name) }.map { $0.name }
                
                for input in inputs {
                    module.connectedInputs[input] = .low
                }
            }
        }
    }

    func part1() -> Int {
        setupModules()
        
        var pulseCounter = [Pulse.low: 0, Pulse.high: 0]
        
        for _ in 1...1000 {
            pulseCounter[.low]! += 1
            
            var queue = [("broadcaster", Pulse.low)]
            
            while !queue.isEmpty {
                let currentTuple = queue.removeFirst()
                guard let current = modules.first(where: {$0.name == currentTuple.0} ) else { fatalError("No module") }
                
                for destination in current.destinations {
                    guard let dest = modules.first(where: {$0.name == destination} ) else { continue }
                    
                    dest.receivePulse(currentTuple.1, from: currentTuple.0)
                    
                    if let pulse = dest.sendPulse(currentTuple.1, from: currentTuple.0) {
                        queue.append((destination, pulse))
                    }
                }
                
                for _ in current.destinations {
                    pulseCounter[currentTuple.1]! += 1
                }
            }
        }
        
        return pulseCounter[.high]! * pulseCounter[.low]!
    }

    func part2() -> Int {
        setupModules()
        
        // Who sends signals to rx ?
        guard let rxSender = modules.first(where: { $0.destinations.contains("rx") }) else { fatalError() }
        
        // For rxSender to send a low pulse all of its input have to be high at the same time
        let rxSenderInputs = modules.filter { $0.destinations.contains(rxSender.name) }
        
        // When do those send a high ?
        var whens = rxSenderInputs.reduce(into: [String: Int]()) {
            $0[$1.name] = 0
        }
        var counter = 0
        
        while !whens.values.allSatisfy( { $0 != 0 } ) {
            var queue = [("broadcaster", Pulse.low)]
            counter += 1
            
            while !queue.isEmpty {
                let currentTuple = queue.removeFirst()
                guard let current = modules.first(where: {$0.name == currentTuple.0} ) else { fatalError("No module") }
                
                for destination in current.destinations {
                    guard let dest = modules.first(where: {$0.name == destination} ) else { continue }
                    
                    dest.receivePulse(currentTuple.1, from: currentTuple.0)
                    
                    if let pulse = dest.sendPulse(currentTuple.1, from: currentTuple.0) {
                        queue.append((destination, pulse))
                    }
                    
                    for name in whens.keys {
                        if whens[name] == 0 && modules.first(where: { $0.name == name })!.sentHigh {
                            whens[name] = counter
                        }
                    }
                }
            }
        }
        
        return whens.values.reduce(1, *)
    }
}
