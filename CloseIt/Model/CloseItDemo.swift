//
//  CloseItDemo.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 23.07.2024.
//

import Foundation

class CloseItDemo: CloseItClass, Identifiable, ObservableObject {
    enum DemoType: String {
        case image = "image"
        case board = "board"
        case text = "text"
    }
    
    private var data: CloseItDataDemo
    @Published var objectIndex: Int = 0
    var game: CloseItGame? = nil
    
    init (data: CloseItDataDemo) {
        self.data = data
    }
    
    var id: String {
        return data.id
    }
    
    var demoType: DemoType {
        let dt = DemoType(rawValue: data.demoType)
        
        if dt == nil {
            myMessage.error("undexpected demoType '\(data.demoType)'")
        }
        return dt!
    }
    
    var demoName: String {
        let demoName = CloseIt.getLocalizedText(type: "demoName", id: id)
        
        return demoName
    }
    
    override func helpType () -> String {
        return data.type
    }
    
    override func helpId () -> String {
        var helpId = data.id
        
        if objects.count > 1 {
            helpId += separator + "\(objectIndex)"
        }
        return helpId
    }
    
    var objects: [String] {
        return data.demoObject
    }
    
    func object () -> String {
        CLOSEIT_TYPE_FUNC_START(self)
        var o = ""
        
        if data.demoObject.count > 0 {
            o = data.demoObject[0]
        }
        CLOSEIT_TYPE_FUNC_END(self)
        return o
    }
    
    func nextObject () -> String {
        CLOSEIT_TYPE_FUNC_START(self)
        var o = ""
        
        if objectIndex < data.demoObject.count {
            o = data.demoObject[objectIndex]
            objectIndex += 1
        }
        CLOSEIT_TYPE_FUNC_START(self)
        return o
    }
    
    func prevObject () -> String {
        CLOSEIT_TYPE_FUNC_START(self)
        var o = ""
        
        if objectIndex > 0 {
            o = data.demoObject[objectIndex - 1]
            objectIndex -= 1
        }
        CLOSEIT_TYPE_FUNC_START(self)
        return o
    }
        
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        let s = data.value(showName: showName, sep: sep)
        
        return s
    }
}

class CloseItDemos: CloseItClass, ObservableObject {
    var demos: [CloseItDemo] = []
    
    private func load () {
        var dataDemos: [CloseItDataDemo] = []
        
        CloseItDataDemo.load(data: &dataDemos)
        for d in dataDemos {
            demos.append(CloseItDemo(data: d))
        }
    }
    
    override init () {
        super.init()
        load()
    }
    
    var count: Int {
        return demos.count
    }
    
    func setGames (games: CloseItGames) {
        for d in demos {
            if d.demoType == .board {
                for g in games.data {
                    var oid = g.game.board.boardId
                    
                    if (g.game.board.isChallenge) {
                        oid += separator + g.game.board.challenge
                    }
                    if d.object() == oid {
                        d.game = g.game
                        break
                    }
                }
                if d.game == nil {
                    myMessage.error("unexpected object '\(d.object())'")
                }
            }
        }
    }
}
