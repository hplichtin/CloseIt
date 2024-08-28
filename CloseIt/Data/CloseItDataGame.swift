//
//  CloseItDataGame.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 02.12.21.
//

import Foundation
import Combine

struct CloseItDataGame: Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "game"
    static let version = "v1"
        
    static func == (lhs: CloseItDataGame, rhs: CloseItDataGame) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func load (url: URL, data: inout [CloseItDataGame]) {
        let loadedData: Data? = CloseItData.load(url: url)
        
        if loadedData != nil {
            let d: [CloseItDataGame] = loadCloseItData(data: loadedData!)
            
            data += d
        }
    }
    
    static func store (url: URL, data: [CloseItDataGame]) {
        storeCloseItData(t: data, url: url)
    }

    var program: String
    var type: String
    var version: String
    var id: UUID
    var userId: String
    var boardId: String
    var boardSizeX: Int
    var boardSizeY: Int
    var boardCells: String
    var target: String
    var challenge: String
    var level: Level
    var actions: String
    var steps: [Int]

    init(program: String = CloseIt.program,
         type: String = CloseItDataGame.type,
         version: String = CloseItDataGame.version,
         id: UUID,
         userId: String,
         boardId: String,
         boardSizeX: Int,
         boardSizeY: Int,
         boardCells: String,
         target: String,
         challenge: String,
         level: Level,
         actions: String) {
        self.program = program
        self.type = type
        self.version = version
        self.id = id
        self.userId = userId
        self.boardId = boardId
        self.boardSizeX = boardSizeX
        self.boardSizeY = boardSizeY
        self.boardCells = boardCells
        self.target = target
        self.challenge = challenge
        self.level = level
        self.actions = actions
        self.steps = []
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
     
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "id:" : "" ) + "\(id)" + sep
        s += ( showName ? "userId:" : "" ) + userId + sep
        s += ( showName ? "boardId:" : "" ) + boardId + sep
        s += ( showName ? "boardSizeX:" : "" ) + "\(boardSizeX)" + sep
        s += ( showName ? "boardSizeY:" : "" ) + "\(boardSizeY)" + sep
        s += ( showName ? "boardCells:" : "" ) + boardCells + sep
        s += ( showName ? "target:" : "" ) + target + sep
        s += ( showName ? "challenge:" : "" ) + challenge + sep
        s += ( showName ? "level:" : "" ) + "\(level)" + sep
        s += ( showName ? "actions:" : "" ) + actions
        s += ( showName ? "steps:" : "" ) + "["
        var i = 0
        for st in steps {
            s += "\(st)"
            if i < steps.count - 1 {
                s += ", "
            }
            i += 1
        }
        s += "]"
        return s
    }
    
    var description: String {
        return "[CloseItDataGame|id:\(id)]"
    }
}
