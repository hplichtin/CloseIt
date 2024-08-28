//
//  CloseItDataDemo.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin 23-Jul-2024.
//

import Foundation

struct CloseItDataDemo: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "demo"
    static let version = "v1"
    
    var program: String
    var type: String
    var version: String
    var id: String
    var demoType: String
    var demoObject: [String]

    static func == (lhs: CloseItDataDemo, rhs: CloseItDataDemo) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func load (data: inout [CloseItDataDemo]) {
        let url = CloseItData.getURL(bundleFileName: type)
        let d: [CloseItDataDemo] = loadCloseItData(url: url)
        
        data += d
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
        
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "id:" : "" ) + id + sep
        s += ( showName ? "demoType:" : "" ) + demoType + sep
        s += ( showName ? "demoObject" : "" ) + "["
        var i = 0
        while i < demoObject.count {
            s += demoObject[i]
            i += 1
            if i < demoObject.count {
                s += ","
            }
        }
        s += "]"
        return s
    }
    
    var description: String {
        return "[CloseItDataDemo|id:\(id)]"
    }
}
