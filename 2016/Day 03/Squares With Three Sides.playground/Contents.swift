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

func check(_ triangle: String) throws -> Bool {
    var sides = Array(triangle.components(separatedBy: "  ").dropFirst())
    
    if sides.count == 4 {
        sides = sides.filter { $0.characters.count > 0 }
    }
    
    guard sides.count == 3 else { throw E.illegal(reason: "triangle should have 3 sides \(sides)") }
    
    sides = Array(sides.map({ (side) -> String in
        if side.substring(to: side.index(after: side.startIndex)) == " " {
            return side.substring(from: side.index(after: side.startIndex))
        } else if side.characters.count > 2 && side.substring(to: side.index(side.startIndex, offsetBy: 2)) == "  " {
            return side.substring(from: side.index(side.startIndex, offsetBy: 2))
        } else { return side }
    }))
    
    guard let a = Int(sides[0]), let b = Int(sides[1]), let c = Int(sides[2]) else { throw E.unwrap(reason: "Couldn't convert \(sides) to int") }
    
    print("a: \(a), b: \(b), c: \(c)  |  a+b<c: \(a+b<c) | a+c<b: \(a+c<b) | b+c<a: \(b+c<a)    count: \(count)")
    
    return !(a+b<c) && !(a+c<b) && !(b+c<a)
}

var count: Int = 0

do {
    let input = try getInput()
    let triangles = input.components(separatedBy: "\n").dropLast()
    triangles.count
    
    
    for triangle in triangles {
        if try check(triangle) {
            count += 1
//            print("\(triangle): count is now \(count)")
        }
    }
    
    print(count)
    
} catch let e {
    print("Oops: \(e)")
}