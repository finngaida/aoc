//: Playground - noun: a place where people can play

import Foundation

enum E: Error {
    case unwrap(reason: String)
    case illegal(reason: String)
}

func getInput() throws -> String {
    return "edjrjqaa"
}

do {
    let input = try getInput()
    
    
} catch let e {
    print("Oops: \(e)")
}
