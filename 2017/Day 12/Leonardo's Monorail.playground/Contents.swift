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

enum Register {
    case a, b, c, d
}

enum Command {
    case cpy(a: Int, b: Register)
    case inc(reg: Register)
    case dec(reg: Register)
    case jnz(cmp: Int, a: Int)
}

var a: Int = 0
var b: Int = 0
var c: Int = 0
var d: Int = 0

func readReg(_ reg: Register) -> Int {
    switch reg {
    case .a:
        return a
    case .b:
        return b
    case .c:
        return c
    case .d:
        return d
    }
}

func setReg(_ reg: Register, value: Int) {
    switch reg {
    case .a:
        a = value
    case .b:
        b = value
    case .c:
        c = value
    case .d:
        d = value
    }
}

func register(for code: Character) throws -> Register {
    switch code {
    case "a":
        return .a
    case "b":
        return .b
    case "c":
        return .c
    case "d":
        return .d
    default:
        throw E.illegal(reason: "no regsiter for code \(code)")
    }
}

func command(for cmd: String) throws -> Command {
    let parts = cmd.components(separatedBy: " ")
    let cmnd = cmd.substring(to: cmd.index(cmd.startIndex, offsetBy: 3))
    
    switch cmnd {
        case "cpy":
            guard parts.count == 3 else { throw E.illegal(reason: "illegal parameter count on \(cmd)") }
            guard parts[2].characters.count == 1 else { throw E.illegal(reason: "illegal register in \(cmd)") }
            let b = try register(for: Character(parts[2]))
            if let a = Int(parts[1]) {
                return Command.cpy(a: a, b: b)
            } else if parts[1].characters.count == 1 {
                let a = readReg(try register(for: Character(parts[1])))
                return Command.cpy(a: a, b: b)
            } else {
                throw E.illegal(reason: "illegal command \(cmd)")
            }
        case "inc":
            guard parts.count == 2 else { throw E.illegal(reason: "illegal parameter count on \(cmd)") }
            guard parts[1].characters.count == 1 else { throw E.illegal(reason: "illegal register in \(cmd)") }
            let a = try register(for: Character(parts[1]))
            return Command.inc(reg: a)
        case "dec":
            guard parts.count == 2 else { throw E.illegal(reason: "illegal parameter count on \(cmd)") }
            guard parts[1].characters.count == 1 else { throw E.illegal(reason: "illegal register in \(cmd)") }
            let a = try register(for: Character(parts[1]))
            return Command.dec(reg: a)
        case "jnz":
            guard parts.count == 3 else { throw E.illegal(reason: "illegal parameter count on \(cmd)") }
            guard let b = Int(parts[2]) else { throw E.illegal(reason: "couldnt convert to int in \(cmd)") }
            if let a = Int(parts[1]) {
                return Command.jnz(cmp: a, a: b)
            } else if parts[1].characters.count == 1 {
                let a = readReg(try register(for: Character(parts[1])))
                return Command.jnz(cmp: a, a: b)
            } else {
                throw E.illegal(reason: "illegal command \(cmd)")
            }
        default: throw E.illegal(reason: "unknown command \(cmd)")
    }
}

var commandsCount: Int = 0
var currentCommand: Int = 0

func execute(command: Command) {
    switch command {
    case .cpy(let a, let b):
        setReg(b, value: a)
    case .inc(let reg):
        setReg(reg, value: readReg(reg)+1)
    case .dec(let reg):
        setReg(reg, value: readReg(reg)-1)
    case .jnz(let cmp, let a):
        if cmp != 0 {
            currentCommand += a
        }
    }
}

do {
    let input = try getInput()
    let commands = input.components(separatedBy: "\n")
    commandsCount = commands.count
    
    while currentCommand < commandsCount {
        let cmd = try command(for: commands[currentCommand])
        execute(command: cmd)
        print("current: \(currentCommand) = '\(commands[currentCommand])' = \(cmd)| total: \(commandsCount) | a: \(a), b: \(b), c: \(c), d: \(d)")
        currentCommand += 1
    }
    
    print(a)
    
} catch let e {
    print("Oops: \(e)")
}

/*
 
 a = 3
 b = 2
 c = 2
 d = 24
 
 */