//: Playground - noun: a place where people can play

import Foundation

enum E: Error {
    case unwrap(reason: String)
}

func getInput() throws -> String {
    guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else { throw E.unwrap(reason: "Couldn't create path for input file") }
    guard let input = try? String(contentsOfFile: path) else { throw E.unwrap(reason: "couldn't read input") }
    return input
}

func isValid(_ phrase: String) -> Bool {
    let words = phrase.components(separatedBy: " ")
    for (i, word) in words.enumerated() {
        for j in i+1..<words.count {
            if word == words[j] {
                return false
            }
        }
    }
    return true
}

do {
    let input = try getInput()
    let phrases = Array(input.components(separatedBy: "\n").dropLast())
    let result = phrases.reduce(0, { isValid($1) ? $0 + 1 : $0 })

    print(result)
} catch let e {
    print(e)
}
