//: Playground - noun: a place where people can play

import Foundation

enum E: Error {
    case unwrap(reason: String)
    case illegal(reson: String)
}

func getInput() throws -> String {
    guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else { throw E.unwrap(reason: "Couldn't create path for input file") }
    guard let input = try? String(contentsOfFile: path) else { throw E.unwrap(reason: "couldn't read input") }
    return input
}

extension Array {
    func rotate(shift:Int) -> Array {
        var array = Array()
        if (self.count > 0) {
            array = self
            if (shift < 0) {
                for _ in 1...shift {
                    array.append(array.remove(at: 0))
                }
            }
            else if (shift > 0) {
                for _ in 1...abs(shift) {
                    array.insert(array.remove(at: array.count-1),at:0)
                }
            }
        }
        return array
    }
}

enum Command {
    case rect(params: [String])
    case rRow(params: [String])
    case rCol(params: [String])
}

func command(from: String) throws -> Command {
    let components = from.components(separatedBy: " ")
    guard components.count >= 2 else { throw E.unwrap(reason: "not enough commands in \(from)") }
    let params = Array(components[1..<components.count])
    
    if let cmd = components.first, let para = params.first {
        switch cmd {
        case "rect":
            return Command.rect(params: params)
        case "rotate" where para == "row":
            return Command.rRow(params: params)
        case "rotate" where para == "column":
            return Command.rCol(params: params)
        default: break
        }
    }
    throw E.unwrap(reason: "Command \(from) not known")
}

func light(rect: String) throws {
    let components = rect.components(separatedBy: "x")
    guard components.count == 2 else { throw E.unwrap(reason: "not a valid number of commands in \(rect)") }
    guard let left = components.first, let right = components.last, let cols = Int(left), let rows = Int(right) else { throw E.unwrap(reason: "Couldn't convert parameters to int in \(rect)") }
    guard display.count > rows, display[0].count > cols else { throw E.illegal(reson: "rect \(rect) out of bounds") }
    
    for i in 0..<rows {
        for j in 0..<cols {
            display[i][j] = true
        }
    }
}

func rotate(column c: Int, by: Int) throws {
    let map = try display.map({ array -> Bool in
        guard array.count > c else { throw E.illegal(reson: "Column \(c) out of bounds") }
        return array[c]
    })
    map.rotate(shift: by).enumerated().forEach { i, b in
        display[i][c] = b
    }
}

func rotate(row r: Int, by: Int) throws {
    guard display.count > r else { throw E.illegal(reson: "Row \(r) out of bounds") }
    display[r] = display[r].rotate(shift: by)
}

func execute(_ command: Command) throws {
    switch command {
    case .rCol(let params):
        guard params.count == 4 else { throw E.unwrap(reason: "params illegal count: \(command)") }
        guard let colStr = params[1].components(separatedBy: "=").last, let col = Int(colStr) else { throw E.unwrap(reason: "params illegal count: \(command)") }
        guard let by = Int(params[3]) else { throw E.unwrap(reason: "params illegal count: \(command)") }
        try rotate(column: col, by: by)
    case .rRow(let params):
        guard params.count == 4 else { throw E.unwrap(reason: "params illegal count: \(command)") }
        guard let rowStr = params[1].components(separatedBy: "=").last, let row = Int(rowStr) else { throw E.unwrap(reason: "params illegal count: \(command)") }
        guard let by = Int(params[3]) else { throw E.unwrap(reason: "params illegal count: \(command)") }
        try rotate(row: row, by: by)
    case .rect(let params):
        guard let param = params.first else { throw E.unwrap(reason: "no parameter in command \(command)") }
        try light(rect: param)
    }
}

var display: [[Bool]] = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 50), count: 6)

func output(_ cmd: String) {
    print("\n\nCmd: \(cmd)")
    for row in display {
        var rowStr = ""
        for pixel in row {
            rowStr += pixel ? "#" : "."
        }
        print(rowStr)
    }
    print("\n\n")
}

do {
    let input = try getInput()
    
    let commands = input.components(separatedBy: "\n").dropLast()
    
    for cmd in commands {
        let comd = try command(from: cmd)
        try execute(comd)
        output(cmd)
    }
    
    var pixelCount: Int = 0
    for row in display {
        for pixel in row {
            if pixel { pixelCount += 1 }
        }
    }
    print(pixelCount)
} catch let e {
    print("Oops: \(e)")
}