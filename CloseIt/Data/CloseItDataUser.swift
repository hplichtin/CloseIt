//
//  CloseItDataUser.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 04.12.21.
//

import Foundation
import Combine

struct CloseItDataUser: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "user"
    static let version = "v1"
    
    static let localId = "LOCAL"
    static let defautSleepSeconds = 0.1
    
    var program: String
    var type: String
    var version: String
    var source: String
    var id: String
    var alias: String
    var name: String
    
    var level: Level
    
    var isAutoClose: Bool
    var sleepSeconds: Double
    
    static func == (lhs: CloseItDataUser, rhs: CloseItDataUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func load (url: URL, data: inout [CloseItDataUser]) {
        let loadedData: Data? = CloseItData.load(url: url)
        
        if loadedData != nil {
            let d: [CloseItDataUser] = loadCloseItData(data: loadedData!)
            
            data += d
        }
        else {
            let d = CloseItDataUser(source: CloseItDataUser.localId, name: type)
            
            data.append(d)
            store(data: data)
        }
    }
    
    static func load (data: inout [CloseItDataUser]) {
        let url: URL = CloseItData.getURL(userDomainFileName: type + "-" + version)
        
        load(url: url, data: &data)
    }
    
    static func store (url: URL, data: [CloseItDataUser]) {
        storeCloseItData(t: data, url: url)
    }

    static func store (data: [CloseItDataUser]) {
        storeCloseItData(t: data, userDomainFileName: type + "-" + version)
    }

    init(program: String = CloseIt.program,
          type: String = CloseItDataUser.type,
          version: String = CloseItDataUser.version,
          source: String = CloseItDataUser.localId,
          id: String = "",
          alias: String = "",
          name: String = "",
          level: Int = 0,
          isAutoClose: Bool = true,
          sleepSeconds: Double = defautSleepSeconds) {
         self.program = program
         self.type = type
         self.version = version
         self.source = source
         self.id = id != "" ? id : "\(source)(\(UUID()))"
         self.alias = alias
         self.name = name
         self.level = level
         self.isAutoClose = isAutoClose
         self.sleepSeconds = sleepSeconds
    }
    
    var isLocal: Bool {
        return source == CloseItDataUser.localId
    }
   
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
     
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "source:" : "" ) + source + sep
        s += ( showName ? "id:" : "" ) + "\(id)" + sep
        s += ( showName ? "alias:" : "" ) + "\(alias)" + sep
        s += ( showName ? "name:" : "" ) + name + sep
        s += ( showName ? "level:" : "" ) + "\(level)" + sep
        s += ( showName ? "isAutoClose:" : "" ) + "\(isAutoClose)" + sep
        s += ( showName ? "sleepSeconds:" : "" ) + "\(sleepSeconds)"
        return s
    }
    
    var description: String {
        return "[CloseItDataUser|id:\(id)|name:\(name)]"
    }
}
