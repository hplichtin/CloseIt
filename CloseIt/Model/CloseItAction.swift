//
//  CloseItAction.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import Foundation

/// Generic base class for game actions that can be done or undone.
class CloseItAction: CloseItClass {
    // The game the action is for
    var game: CloseItGame
    var canUndo: Bool
    var source: CloseItActionData.Source
    
    init (game: CloseItGame, undo: Bool, source: CloseItActionData.Source) {
        self.game = game
        self.canUndo = undo
        self.source = source
    }
    
    init (action: CloseItAction) {
        self.game = action.game
        self.canUndo = action.canUndo
        self.source = action.source
    }
    
    func copy () -> CloseItAction {
        abort()
    }
    
    func sleep () {
        game.sleep()
    }
    
    var isPlay: Bool {
        return game.isAutoClose
    }
    
    func getFunction () -> CloseItActionData.Function {
        abort()
    }
    
    func doit () {
        abort()
    }
    
    func undoit () {
        abort()
    }
    
    func redoit () {
        abort()
    }
    
    func data (function: CloseItActionData.Function) -> CloseItActionData {
        abort()
    }
}
