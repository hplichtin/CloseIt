//
//  CloseItDataCollection.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 13.11.21.
//

import Foundation
import Combine

struct CloseItDataCollection: CloseItLog, Hashable, Codable, Identifiable, Equatable, CustomStringConvertible {
    static let type = "collection"
    static let version = "v1"
    
    var program: String
    var type: String
    var version: String
    var collectionType: String
    var fileSource: String
    var fileName: String
    
    static func == (lhs: CloseItDataCollection, rhs: CloseItDataCollection) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String {
        return fileSource + CloseIt.separator + fileName
    }
    
    init(program: String = CloseIt.program,
         type: String = CloseItDataCollection.type,
         version: String = CloseItDataCollection.version,
         collectionType: String,
         fileSource: String,
         fileName: String) {
        self.program = program
        self.type = type
        self.version = version
        self.collectionType = collectionType
        self.fileSource = fileSource
        self.fileName = fileName
    }
    
    func helpId() -> String {
        return ""
    }
    
    var description: String {
        return "[CloseItDataCollection|id:\(id)|collectionType:\(collectionType)|fileName:\(fileName)]"
    }
    
    func loadBoards (boards: inout [CloseItDataBoard]) {
        CLOSEIT_TYPE_FUNC_START(self)
        let url = CloseItData.getURL(source: fileSource, fileName: fileName, fileExtension: "")
        let data: [CloseItDataBoard] = loadCloseItData(url: url)
        
        boards += data
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func loadChallenges (challenges: inout [CloseItDataChallenge]) {
        CLOSEIT_TYPE_FUNC_START(self)
        let url = CloseItData.getURL(source: fileSource, fileName: fileName, fileExtension: "")
        let data: [CloseItDataChallenge] = loadCloseItData(url: url)
        
        challenges += data
        CLOSEIT_TYPE_FUNC_END(self)

    }
    
    static func load (url: URL, dataBoards: inout [CloseItDataBoard], dataChallenges: inout [CloseItDataChallenge]) {
        CLOSEIT_FUNC_START()
        let collections: [CloseItDataCollection] = loadCloseItData(url: url)
        
        for c in collections {
            if c.collectionType == CloseItDataBoard.type {
                c.loadBoards(boards: &dataBoards)
            }
            else if c.collectionType == CloseItDataChallenge.type {
                c.loadChallenges(challenges: &dataChallenges)
            }
        }
        CLOSEIT_FUNC_END()
    }
}
