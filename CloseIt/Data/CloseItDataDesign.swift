//
//  CloseItDataDesign.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.12.21.
//

import Foundation

struct CloseItDataDesign: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "design"
    static let version = "v1"
    
    var program: String
    var type: String
    var version: String
    var id: String
    var designer: String
    var size: Int
    var width: Int
    var imageCellIn: String
    var imageCellOut: String
    var imageCellSelected: String
    var imageLineXBorder: String
    var imageLineXIn: String
    var imageLineXOut: String
    var imageLineXSelected: String
    var imageLineYBorder: String
    var imageLineYIn: String
    var imageLineYOut: String
    var imageLineYSelected: String

    static func == (lhs: CloseItDataDesign, rhs: CloseItDataDesign) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func load (data: inout [CloseItDataDesign]) {
        let url = CloseItData.getURL(bundleFileName: type)
        let d: [CloseItDataDesign] = loadCloseItData(url: url)
        
        data += d
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
        
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "id:" : "" ) + id + sep
        s += ( showName ? "designer:" : "" ) + designer + sep
        s += ( showName ? "size:" : "" ) + "\(size)" + sep
        s += ( showName ? "width:" : "" ) + "\(width)"
        return s
    }

    var description: String {
        return "[CloseItDataDesign|id:\(id)]"
    }
}
