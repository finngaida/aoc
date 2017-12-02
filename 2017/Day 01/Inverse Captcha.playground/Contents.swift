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

func matchesNext(index: Int, in string: String) -> Bool {
    return false
}

do {
    let input = try getInput()
    var sum = 0
    for (index, char) in input.enumerated() {
        let nextIndex = input.index(input.startIndex, offsetBy: index)
        if char == input[nextIndex] {
            sum += Int(String(char)) ?? 0
        }
    }
    if input[input.index(input.startIndex, offsetBy: input.count-2)] == input[input.startIndex] {
        sum += Int(String(input[input.startIndex])) ?? 0
    }
    print("The result is \(sum)")
} catch let e {
    print(e)
}
