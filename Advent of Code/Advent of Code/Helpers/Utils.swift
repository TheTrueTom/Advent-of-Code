//
//  Utils.swift
//  2023.3
//
//  Created by Thomas Brichart on 03/12/2023.
//

import Foundation

extension String {
    /// Slice string using range
    ///
    /// ```
    /// "potato"[0...3] == "pota"
    /// ```
    ///
    /// - Parameter range: Range to slice
    /// - Returns: Sliced substring
    subscript(range: ClosedRange<Int>) -> Substring {
        let lowerBound = index(startIndex, offsetBy: range.lowerBound)
        let upperBound = index(startIndex, offsetBy: range.upperBound)
        
        return self[lowerBound...upperBound]
    }
    
    /// Slice string using range with jump
    ///
    /// Similar to Python syntax
    /// ```
    /// "potato"[0...3, -1] == "otatop"
    /// "potato"[0...5, 2] == "ptt"
    /// ```
    ///
    /// - Parameter location: Range to slice
    /// - Parameter jump: Returns every `jump` character.
    /// - Returns: Sliced `String` with jump
    subscript(range: ClosedRange<Int>, jump: Int) -> String? {
        var string = String(self[range])
        
        var finalString = ""
        
        guard jump != 0 else { return nil }
        
        if jump < 0 {
            string = String(string.reversed())
        }
        
        for (index, char) in string.enumerated() {
            if index % abs(jump) == 0 {
                finalString.append(char)
            }
        }
        
        return finalString
    }
    
    /// Get character at location
    ///
    /// ```
    /// "potato"[0] == 'p'
    /// ```
    ///
    /// - Parameter location: Character location
    /// - Returns: Character at `location`
    subscript(location: Int) -> Character {
        let character = index(startIndex, offsetBy: location)
        
        return self[character]
    }
}

extension Sequence where Element: Numeric {
    public var sum: Element { reduce(0, +) }
}
