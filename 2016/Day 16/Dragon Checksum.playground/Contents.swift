//: Playground - noun: a place where people can play

import Foundation

enum E: Error {
    case unwrap(reason: String)
    case illegal(reason: String)
}

func getInput() throws -> String {
    return "11110010111001001"
}

do {
    let input = try getInput()
    
    
} catch let e {
    print("Oops: \(e)")
}
