//
//  CloseItActionReview.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 30.06.24.
//

import Foundation

class CloseItActionReview: CloseItAction {
    private var data: CloseItActionData
    
    static func decode (game: CloseItGame, encodedStr: String) -> [CloseItActionReview] {
        let actionData = CloseItActionData.decode(encodedStr: encodedStr)
        var actions: [CloseItActionReview] = []
        
        for ad in actionData {
            actions.append(CloseItActionReview(game: game, data: ad))
        }
        return actions
    }
    
    init (game: CloseItGame, data: CloseItActionData) {
        self.data = data
        super.init(game: game, undo: false, source: data.source)
    }
    
    init (action: CloseItActionReview) {
        self.data = action.data
        super.init(action: action)
    }
    
    var function: CloseItActionData.Function {
        return data.function
    }
    
    override func copy() -> CloseItAction {
        let action = CloseItActionReview(action: self)
        
        return action
    }
    
    private var object: CloseItObject {
        var obj: CloseItObject
        
        switch data.object {
        case .isCell:
            obj = game.board.cells[data.x][data.y]
        case .isLineX:
            obj = game.board.linesX[data.x][data.y]
        case .isLineY:
            obj = game.board.linesY[data.x][data.y]
        }
        return obj
    }
    
    private static func setObjectStatus (game: CloseItGame, obj: CloseItObject, status: CloseItObject.Status) {
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                game.board.setObject(obj: obj, status: status)
            }
        }
        else {
            game.board.setObject(obj: obj, status: status)
        }
    }
    
    override func getFunction () -> CloseItActionData.Function {
        return function
    }
    
    override func doit() {
        let obj = object
        let status: CloseItObject.Status
        
        switch data.function {
            case .doit: status = data.status
            case .undoit: status = data.status == .isSelected ? .isIn : .isSelected
        }
        CloseItActionReview.setObjectStatus(game: game, obj: obj, status: status)
    }
    
    override func undoit() {
        let obj = object
        let status: CloseItObject.Status

        switch data.function {
            case .doit: status = data.status == .isSelected ? .isIn : .isSelected
            case .undoit: status = data.status
        }
        CloseItActionReview.setObjectStatus(game: game, obj: obj, status: status)
    }

    override func data (function: CloseItActionData.Function) -> CloseItActionData {
        return self.data
    }
}
