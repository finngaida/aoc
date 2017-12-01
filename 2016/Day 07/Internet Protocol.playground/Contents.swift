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

func parts(from input: String) -> ([String], [String]) {
    
    let step1 = input.components(separatedBy: CharacterSet(charactersIn: "[]"))
    
    let externals = step1.enumerated().filter({ $0.0 % 2 == 0}).map({ $0.element })
    let internals = step1.enumerated().filter({ $0.0 % 2 == 1}).map({ $0.element })
    
    return (externals, internals)
}

func abba(in input: String) -> Bool {
    
    var cache1: Character!
    var cache2: Character!
    var cache3: Character!
    var cache4: Character!
    
    for char in input.characters {
        if cache1 == nil {
            cache1 = char
        } else if cache2 == nil {
            cache2 = char
        } else if cache3 == nil {
            cache3 = char
        } else if cache4 == nil {
            cache4 = char
        } else {
            if cache1 != cache2 && cache1 == cache4 && cache2 == cache3 {
                return true
            }
            cache1 = cache2
            cache2 = cache3
            cache3 = cache4
            cache4 = char
        }
    }
    
    return false
}

func supportsTLS(_ input: String) -> Bool {
    
    let components = parts(from: input)
    var abbaInExternals: Bool = false
    var abbaInInternals: Bool = false
    
    for part in components.0 {
        if abba(in: part) { abbaInExternals = true }
    }
    
    for part in components.1 {
        if abba(in: part) { abbaInInternals = true }
    }
    
    return abbaInExternals && !abbaInInternals
}

do {
    let input = try getInput()
    
    let ips = input.components(separatedBy: "\n")
    var count: Int = 0
    
    for ip in ips {
        if supportsTLS(ip) {
            count += 1
            print("\(ip) supports TLS.")
        }
    }
    
    print("\(count) IPs support TLS.")
    
} catch let e {
    print("Oops: \(e)")
}
