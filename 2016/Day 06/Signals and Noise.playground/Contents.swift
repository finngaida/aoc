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

func run(input: String, altCode: Bool) throws -> String {
    
    let codes = input.components(separatedBy: "\n").dropLast()
    
    let chars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"].map({ Character($0) })
    guard let first = codes.first else { throw E.unwrap(reason: "no first code") }
    
    var output: String = ""
    
    for i in 0..<first.characters.count {
        
        var map: [Character:Int] = chars.reduce([Character:Int](), { last, char in
            var ret = last
            ret[char] = 0
            return ret
        })
        
        for code in codes {
            guard code.characters.count > i else { throw E.unwrap(reason: "not enough characters in code \(code)") }
            let char = code.characters[code.index(code.startIndex, offsetBy: i)]
            guard let prev = map[char] else { throw E.unwrap(reason: "Couldn't get previous value of map at index \(i)") }
            map[char] = prev + 1
        }

        let sorted = map.sorted(by: altCode ? { $0.1 < $1.1 } : { $0.1 > $1.1 })
        guard let mostWanted = sorted.first else { throw E.unwrap(reason: "Couldn't find a most frequent letter at index \(i)") }
        output.append(mostWanted.key)
    }
    
    return output
}

do {
    let input = try getInput()
    let secret = try run(input: input, altCode: true)
    print(secret)
} catch let e {
    print("Oops: \(e)")
}