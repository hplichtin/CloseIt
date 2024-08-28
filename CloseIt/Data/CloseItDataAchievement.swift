//
//  CloseItDataAchievement.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 28.07.24.
//

import Foundation

struct CloseItDataAchievement:  Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "achievement"
    static let version = "v1"
    
    var program: String
    var type: String
    var version: String
    var userId: String
    var achievementType: String
    var achievementValue: Int
    var achievementDate: Date
    
    init (program: String = CloseIt.program,
          type: String = CloseItDataAchievement.type,
          version: String = CloseItDataAchievement.version,
          userId: String = "",
          achievementType: String,
          achievementValue: Int) {
        self.program = program
        self.type = type
        self.version = version
        self.userId = userId
        self.achievementType = achievementType
        self.achievementValue = achievementValue
        self.achievementDate = Date()
    }
    
    var id: String {
        return userId + CloseIt.separator + achievementType + CloseIt.separator + "\(achievementValue)"
    }

    static func == (lhs: CloseItDataAchievement, rhs: CloseItDataAchievement) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func load (data: inout [CloseItDataAchievement]) {
        let url = CloseItData.getURL(userDomainFileName: type + "-" + version)
        let loadedData: Data? = CloseItData.load(url: url)
        
        if loadedData != nil {
            let d: [CloseItDataAchievement] = loadCloseItData(data: loadedData!)
            
            data += d
        }
    }
    
    static func store (data: [CloseItDataAchievement]) {
        let url = CloseItData.getURL(userDomainFileName: type + "-" + version)

        storeCloseItData(t: data, url: url)
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
        
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "userId:" : "" ) + userId + sep
        s += ( showName ? "achievementType:" : "" ) + achievementType + sep
        s += ( showName ? "achievementValue:" : "" ) + "\(achievementValue)" + sep
        s += ( showName ? "achievementDate:" : "" ) + "\(achievementDate)"
        return s
    }

    var description: String {
        return "[CloseItDataAchievement|id:\(id)]"
    }
}
