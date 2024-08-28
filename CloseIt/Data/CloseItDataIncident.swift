//
//  CloseItDataIncident.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 13.06.24
//

import Foundation
import Combine

struct CloseItDataIndicent: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "incident"
    static let version = "v1"
    
    var program: String
    var type: String
    var version: String
    var id: Int
    var reportedBy: String
    var reportedDate: String
    var reportedProgramVersion: String
    var incidentType: String
    var incidentTitle: String
    var incidentDescription: String
    var incidentStatus: String
    var resolvedProgramVersion: String
    
    static func == (lhs: CloseItDataIndicent, rhs: CloseItDataIndicent) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func load (data: inout [CloseItDataIndicent]) {
        let url = CloseItData.getURL(bundleFileName: type)
        let d: [CloseItDataIndicent] = loadCloseItData(url: url)
        
        data += d
    }
    
    init(program: String = CloseIt.program,
         type: String = CloseItDataFeature.type,
         version: String = CloseItDataFeature.version,
         id: Int,
         reportedBy: String,
         reportedDate: String,
         reportedProgramVersion: String,
         incidentType: String,
         incidentTitle: String,
         incidentDescription: String,
         incidentStatus: String,
         resolvedProgramVersion: String) {
        self.program = program
        self.type = type
        self.version = version
        self.id = id
        self.reportedBy = reportedBy
        self.reportedDate = reportedDate
        self.reportedProgramVersion = reportedProgramVersion
        self.incidentType = incidentType
        self.incidentTitle = incidentTitle
        self.incidentDescription = incidentDescription
        self.incidentStatus = incidentStatus
        self.resolvedProgramVersion = resolvedProgramVersion
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
     
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "id:" : "" ) + "\(id)" + sep
        s += ( showName ? "incident:" : "" ) + incidentType + sep
        s += ( showName ? "reportedBy:" : "" ) + reportedBy + sep
        s += ( showName ? "reportedDate:" : "" ) + reportedDate + sep
        s += ( showName ? "reportedProgramVersion:" : "" ) + reportedProgramVersion + sep
        s += ( showName ? "title:" : "" ) + incidentTitle + sep
        s += ( showName ? "incidentDescription:" : "" ) + incidentDescription + sep
        s += ( showName ? "incidentStatus:" : "" ) + incidentStatus + sep
        s += ( showName ? "resolvedProgramVersion:" : "" ) + resolvedProgramVersion
        return s
    }
    
    var description: String {
        return "[CloseItDataIncident|id:\(id)]"
    }
}
