//: Playground - noun: a place where people can play

import Foundation

enum E: Error {
    case unwrap(reason: String)
    case illegal(reason: String)
}

func getInput() throws -> String {
    guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else { throw E.unwrap(reason: "Couldn't create path for input file") }
    guard let input = try? String(contentsOfFile: path) else { throw E.unwrap(reason: "couldn't read input") }
    return input
}

func go(_ cmd: Character, from: Int) throws -> Int {
    guard from >= 1 && from <= 9 else { throw E.illegal(reason: "Illegal start \(from)") }
    switch cmd {
        case "R":
            if from == 3 || from == 6 || from == 9 { return from }
            else { return from+1 }
        case "L":
            if from == 1 || from == 4 || from == 7 { return from }
            else { return from-1 }
        case "U":
            if from <= 3 { return from }
            else { return from-3 }
        case "D":
            if from >= 7 { return from }
            else { return from+3 }
    default:
        throw E.illegal(reason: "illegal command \(cmd)")
    }
}

func go2(_ cmd: Character, from: Int) throws -> Int {
    guard from >= 1 && from <= 13 else { throw E.illegal(reason: "Illegal start \(from)") }
    switch cmd {
    case "R":
        if from == 1 || from == 4 || from == 9 || from == 12 || from == 13 { return from }
        else { return from+1 }
    case "L":
        if from == 1 || from == 2 || from == 5 || from == 10 || from == 13 { return from }
        else { return from-1 }
    case "U":
        if from == 1 || from == 2 || from == 4 || from == 5 || from == 9 { return from }
        else {
            if from == 3 || from == 13 {
                return from-2
            } else if from >= 6 && from <= 12 {
                return from-4
            } else { throw E.illegal(reason: "illegal \(from)") }
        }
    case "D":
        if from == 5 || from == 9 || from == 10 || from == 12 || from == 13 { return from }
        else {
            if from == 1 || from == 11 {
                return from+2
            } else if from >= 2 && from <= 8 {
                return from+4
            } else { throw E.illegal(reason: "illegal \(from)") }
        }
    default:
        throw E.illegal(reason: "illegal command \(cmd)")
    }
}

func perform(code: String, starting with: Int) throws -> Int {
    var cache: Int = with
    for char in code.characters {
        let new = try go2(char, from: cache)
//        print("Going \(char) from \(cache) to \(new)")
        cache = new
    }
    return cache
}

do {
    let input = try getInput()
    let codes = Array(input.components(separatedBy: "\n").dropLast())
    
    var final: String = ""
    var cache: Int = 5
    for code in codes {
        let digit = try perform(code: code, starting: cache)
        
        if cache < 10 {
            final += "\(cache)"
        } else if cache <= 13 {
            final += ["A", "B", "C", "D"][cache-10]
        }
        
        cache = digit
    }
    
    print(final)
} catch let e {
    print("Oops: \(e)")
}