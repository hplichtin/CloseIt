//
//  CloseItDataControl.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 13.12.21.
//

import Foundation
import Combine

struct CloseItDataControl: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "control"
    static let version = "v1"
    
    var program: String
    var type: String
    var version: String
    var id: UUID
    
    private var admin = false // not used
    private var debug = false
    var applicationView: String = ""
    var gameCompleted = false
    var designId: String = CloseItControl.Resources.defaultDesignId
    var currentUserId: String = ""
    var zoom: Double = 1.0
    private var shapeSize = false // not used
    var showInfoNames = false
    
    static func == (lhs: CloseItDataControl, rhs: CloseItDataControl) -> Bool {
        return lhs.id == rhs.id
    }
    
    init (program: String = CloseIt.program,
         type: String = CloseItDataControl.type,
         version: String = CloseItDataControl.version
     ) {
        self.program = program
        self.version = version
        self.type = type
        self.id = UUID()
    }
    
    mutating func load (url: URL) -> Bool {
        let loadedData: Data? = CloseItData.load(url: url)
        
        if loadedData != nil {
            let data: CloseItDataControl = loadCloseItData(data: loadedData!)
            
            self = data
            return true
        }
        return false
    }
    
    mutating func load () -> Bool {
        let url: URL = CloseItData.getURL(userDomainFileName: type  + "-" + version)
        
        return load(url: url)
    }
    
    func store (url: URL) {
        storeCloseItData(t: self, url: url)
    }

    func store () {
        storeCloseItData(t: self, userDomainFileName: type  + "-" + version)
    }

    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
     
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "id:" : "" ) + "\(id)" + sep
        s += ( showName ? "debug:" : "" ) + "\(debug)" + sep
        s += ( showName ? "designId:" : "" ) + designId + sep
        s += ( showName ? "currentUserId:" : "" ) + currentUserId + sep
        s += ( showName ? "zoom:" : "" ) + "\(zoom)" + sep
        s += ( showName ? "showInfoNames:" : "" ) + "\(showInfoNames)"
        return s
    }

    var description: String {
        return "[CloseItDataControl|id:\(id)]"
    }
}
