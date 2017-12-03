//: Playground - noun: a place where people can play

import Foundation

enum E: Error {
    case unwrap(reason: String)
    case illegal(reason: String)
}

func getInput() throws -> Int {
    return 325489
}

do {
    let input = try getInput()

    // create circle
    var i = 0
    var circle = 0
    while true {
        let sideLength = (circle+1) * 2 - 1
        let capacity = sideLength * 4

        if i + capacity > input {
            circle
            sideLength
            capacity
            let positionInCircle = input % i
            let side = positionInCircle / sideLength
            let positionInSide = positionInCircle % sideLength
            let result = circle + abs((sideLength/2)-positionInSide)
            print(result)
            
            break
        }

        i += capacity
        circle += 1
    }
    
} catch let e {
    print("Oops: \(e)")
}
