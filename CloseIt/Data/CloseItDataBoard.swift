//
//  CloseItDataBoard.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 13.11.21.
//

import Foundation
import Combine

struct CloseItDataBoard: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "board"
    static let version = "v1"
    
    var program: String
    var type: String
    var version: String
    var group: String
    var id: String
    var designer: String
    var sizeX: Int
    var sizeY: Int
    var cells: String
    var target: String
    
    static func == (lhs: CloseItDataBoard, rhs: CloseItDataBoard) -> Bool {
        return lhs.id == rhs.id
    }
    
    init (program: String = CloseIt.program,
          type: String = CloseItDataBoard.type,
          version: String = CloseItDataBoard.version,
          group: String,
          id: String,
          designer: String = CloseIt.designer,
          sizeX: Int,
          sizeY: Int,
          cells: String,
          target: String = "") {
        self.program = program
        self.type = type
        self.version = version
        self.group = group
        self.id = id
        self.designer = designer
        self.sizeX = sizeX
        self.sizeY = sizeY
        self.cells = cells
        self.target = target
    }
    
    init (group: String, dataGame: CloseItDataGame) {
        program = CloseIt.program
        type = CloseItDataBoard.type
        version = CloseItDataBoard.version
        self.group = group
        id = dataGame.boardId
        designer = CloseIt.designer
        sizeX = dataGame.boardSizeX
        sizeY = dataGame.boardSizeY
        cells = dataGame.boardCells
        target = dataGame.target
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
        
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "group:" : "" ) + group + sep
        s += ( showName ? "id:" : "" ) + id + sep
        s += ( showName ? "designer:" : "" ) + designer + sep
        s += ( showName ? "sizeX:" : "" ) + "\(sizeX)" + sep
        s += ( showName ? "sizeY:" : "" ) + "\(sizeY)" + sep
        s += ( showName ? "cells:" : "" ) + cells + sep
        s += ( showName ? "target:" : "" ) + target
        return s
    }

    var description: String {
        return "[CloseItDataBoard|id:\(id)]"
    }
}
