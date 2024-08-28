//
//  CloseItDataChallenge.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 20.12.21.
//

import Foundation

struct CloseItDataChallenge: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "challenge"
    static let version = "v1"
    
    var program: String
    var type: String
    var version: String
    var designer: String
    var group: String
    var boardId: String
    var challenge: String
    var level: Level
    var availableAfterDays: Int

    var id: String {
        return boardId + CloseIt.separator + challenge
    }

    static func == (lhs: CloseItDataChallenge, rhs: CloseItDataChallenge) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func load (data: inout [CloseItDataChallenge]) {
        let url = CloseItData.getURL(bundleFileName: type)
        let d: [CloseItDataChallenge] = loadCloseItData(url: url)
        
        data += d
    }

    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
        
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "designer:" : "" ) + designer + sep
        s += ( showName ? "group:" : "" ) + group + sep
        s += ( showName ? "id:" : "" ) + id + sep
        s += ( showName ? "boardId:" : "" ) + boardId + sep
        s += ( showName ? "challenge:" : "" ) + challenge + sep
        s += ( showName ? "level:" : "" ) + "\(level)" + sep
        s += ( showName ? "availableAfterDays:" : "" ) + "\(availableAfterDays)"
        return s
    }
    var description: String {
        return "[CloseItDataChallange|id:\(id)]"
    }
}
