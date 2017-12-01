//: Playground - noun: a place where people can play

import Foundation

enum E: Error {
    case done(output: String)
    case unwrap(reason: String)
    case illegal(reason: String)
}

func getInput() throws -> String {
    guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else { throw E.unwrap(reason: "Couldn't create path for input file") }
    guard let input = try? String(contentsOfFile: path) else { throw E.unwrap(reason: "couldn't read input") }
    return input
}

do {
    let input = try getInput()
    let nsInput = input as NSString
    var output = ""
    let scanner = Scanner(string: input)
    
    var current: NSString?
    while scanner.scanUpTo("(", into: &current) {
        
        if let c = current as? String { output.append(c) }
        
        var marker: NSString?
        guard scanner.scanUpTo(")", into: &marker) else { throw E.done(output: output) }
        guard let m = marker?.substring(from: 1) else { throw E.unwrap(reason: "Couldn't strip bracket from \(marker)") }
        
        let components = m.components(separatedBy: "x")
        guard components.count == 2 else { throw E.illegal(reason: "Marker should have only two parameters") }
        guard let l = Int(components[0]), let r = Int(components[1]) else { throw E.unwrap(reason: "Couldn't convert components \(components) to int") }
        
        let strToCpy = nsInput.substring(with: NSMakeRange(scanner.scanLocation+1, l))
        (0..<r).forEach { _ in output.append(strToCpy) }
        scanner.scanLocation += (1+r*l)
    }
    
    print(output)
    print(output.characters.count)
    
} catch E.done(let output) {
    
} catch let e {
    print("Oops: \(e)")
}
