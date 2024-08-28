//
//  CloseItDataConfig.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 27.08.24.
//

import Foundation
import Combine

struct CloseItDataConfig: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "config"
    static let version = "v1"

    var program: String
    var type: String
    var version: String
    var id: String
    var adminUserIds: [String]
    
    static func == (lhs: CloseItDataConfig, rhs: CloseItDataConfig) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func load () -> CloseItDataConfig {
        let url = CloseItData.getURL(bundleFileName: type)
        let d: CloseItDataConfig = loadCloseItData(url: url)
        
        return d
    }
    
    init(program: String = CloseIt.program,
          type: String = CloseItDataConfig.type,
          version: String = CloseItDataConfig.version,
          id: String,
          adminUserIds: [String]) {
        self.program = program
        self.type = type
        self.version = version
        self.id = id
        self.adminUserIds = adminUserIds
    }
    
    func value (showName: Bool = false, sep: String =  CloseIt.separator) -> String {
        var s: String = ""
     
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "id:" : "" ) + id + sep
        s += ( showName ? "adminUserIds:" : "" ) + adminUserIds.description
        return s
    }
    
    var description: String {
        return "[CloseItDataConfig|id:\(id)]"
    }
}
