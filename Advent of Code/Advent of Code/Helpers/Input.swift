//
//  Input.swift
//  Advent of Code
//
//  Created by Thomas Brichart on 16/11/2023.
//

import Foundation

func readInput(fromTestFile: Bool) throws -> String {

    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let url = URL(fileURLWithPath: fromTestFile ? "test_input.txt" : "input.txt", relativeTo: currentDirectoryURL)

    do {
        let contents = try String(contentsOfFile: url.path, encoding: .utf8)
        return contents
    }
    catch let error {
        print("Input parsing failed: \(error)")
        throw error
    }
}
