//
//  CloseItDataHelp.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 09-Jul-2024.
//

import Foundation

typealias Level = Int

struct CloseItDataLevel: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "level"
    static let version = "v1"
    
    var program: String
    var type: String
    var version: String
    var level: Level

    static func == (lhs: CloseItDataLevel, rhs: CloseItDataLevel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func load (data: inout [CloseItDataLevel]) {
        let url = CloseItData.getURL(bundleFileName: type)
        let d: [CloseItDataLevel] = loadCloseItData(url: url)
        
        data += d
    }
    
    init (program: String = CloseIt.program, type: String = type, version: String = version, level: Level) {
        self.program = program
        self.type = type
        self.version = version
        self.level = level
    }
    
    var id: Int {
        return level
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
        
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "level:" : "" ) + "\(level)"
        return s
    }
    
    var description: String {
        return "[CloseItDataLevel|id:\(id)]"
    }
}
