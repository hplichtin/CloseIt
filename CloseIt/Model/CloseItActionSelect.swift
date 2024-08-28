//
//  CloseItActionSelectObject.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import Foundation

class CloseItActionSelectLine: CloseItAction {
    private var obj: CloseItObject
    private var user: CloseItUser
    private var oldStatus: CloseItObject.Status = .isOut
    private var newStatus: CloseItObject.Status = .isOut

    init (game: CloseItGame, user: CloseItUser, obj: CloseItObject, source: CloseItActionData.Source) {
        self.obj = obj
        self.user = user
        super.init(game: game, undo: true, source: source)
    }
        
    init (action: CloseItActionSelectLine) {
        self.obj = action.obj
        self.user = action.user
        super.init(action: action)
    }
    
    override func copy() -> CloseItAction {
        let action = CloseItActionSelectLine(action: self)
        
        return action
    }
   
    enum Function {
        case doit, redoit, undoit
    }
    
    private func doit(_ function: Function) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(obj.isLine)
        var score: CloseItScore
        
        // setup score
        if game.myScore == nil {
            myMessage.error("game.myScore == nil")
        }
        score = game.myScore!
        // store status for undo
        // select object
        DispatchQueue.main.sync {
            if function != .undoit {
                oldStatus = obj.status
                game.setObject(obj: obj, status: obj.isSelected ? .isIn : .isSelected, userId: user.id)
                newStatus = obj.status
            }
            else {
                game.board.setObject(obj: obj, status: oldStatus, userId: user.id)
            }
            // update score
            if !obj.isSelected && function == .doit {
                score.incNumUndos()
            }
            score.addNumSelectedLines(type: obj.type, num: obj.isSelected ? 1 : -1)
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    override func doit() {
        doit(.doit)
    }
    
    override func undoit() {
        doit(.undoit)
    }
    
    override func redoit() {
        doit(.redoit)
    }

    override func data (function: CloseItActionData.Function) -> CloseItActionData {
        let actionData = CloseItActionData(function: function, object: obj.type, status: newStatus, x: obj.x, y: obj.y, source: source)
        
        return actionData
    }
}

class CloseItActionSelectCell: CloseItAction {
    private var obj: CloseItObject
    private var oldObj: CloseItObject? = nil
    private var newStatus: CloseItObject.Status = .isOut
    private var user: CloseItUser
    
    private var copyMyScore: CloseItScore? = nil
    private var copyOtherScore: CloseItScore? = nil
    
    init (game: CloseItGame, user: CloseItUser, obj: CloseItObject, source: CloseItActionData.Source) {
        self.obj = obj
        self.user = user
        super.init(game: game, undo: true, source: source)
    }
    
    init (action: CloseItActionSelectCell) {
        self.obj = action.obj
        self.oldObj = action.oldObj
        self.user = action.user
        self.copyMyScore = action.copyMyScore
        self.copyOtherScore = action.copyOtherScore
        super.init(action: action)
    }
    
    override func copy() -> CloseItAction {
        let action = CloseItActionSelectCell(action: self)
        
        return action
    }

/*    private func selectCell (x: Int, y: Int, source: CloseItActionData.Source) {
        let cell = game.board.cells[x][y]
        
        if game.board.isObjectSelectable(obj: cell) {
            let action = CloseItActionSelectCell(game: game, user: user, obj: cell, source: source)
            
            game.doit(action: action)
        }
    }
    
    private func selectLine (type: CloseItObject.Object, x: Int, y: Int, source: CloseItActionData.Source) {
        var obj: CloseItObject
        
        if type == .isLineX {
            obj = game.board.linesX[x][y]
        }
        else if type == .isLineY {
            obj = game.board.linesY[x][y]
        }
        else {
            return
        }
        if game.board.isObjectSelectable(obj: obj) {
            let action = CloseItActionSelectCell(game: game, user: user, obj: obj, source: source)
            
            game.doit(action: action)
        }
    }
    
    private func closeCell (x: Int, y: Int, source: CloseItActionData.Source) {
        if game.board.getCellLinesSelectedOrBorderCount(x: x, y: y) == game.board.maxCellCloseItCount() - 1 {
            selectLine(type: .isLineX, x: x, y: y, source: source)
            selectLine(type: .isLineX, x: x, y: y + 1, source: source)
            selectLine(type: .isLineY, x: x, y: y, source: source)
            selectLine(type: .isLineY, x: x + 1, y: y, source: source)
        }
    }
  */
    
    enum Function {
        case doit, redoit
    }
    
    private func doit(_ function: Function) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(obj.isCell)
        
        var score: CloseItScore
        var linesSelected = 0
        let maxSelectedLines = game.board.maxCellCloseItCount()
        
        // setup score
        if game.myScore == nil {
            myMessage.error("game.myScore == nil")
        }
        score = game.myScore!
        // copy scores and object to enable undo
        game.copyScores(copyMyScore: &copyMyScore, copyOtherScore: &copyOtherScore)
        oldObj = CloseItObject(obj: obj)
        DispatchQueue.main.sync {
            // select object
            self.game.setObject(obj: self.obj, status: .isSelected, userId: self.user.id)
            self.newStatus = self.obj.status
        }

        linesSelected = game.board.getCellLinesSelectedOrBorderCount(x: obj.x, y: obj.y)
        DispatchQueue.main.sync {
            if source == .isUserAction {
                score.resetStreakCount()
            }
            if linesSelected < maxSelectedLines {
                score.incSelectedCells()
                score.incStreakCount()
            }
            else if linesSelected == maxSelectedLines {
                score.incSelectedCells()
                score.resetStreakCount()
                score.incStreakCount()
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    override func doit() {
        doit(.doit)
    }
    
    override func undoit() {
        if oldObj != nil {
            DispatchQueue.main.sync {
                game.board.setObject(obj: obj, status: oldObj!.status, userId: oldObj!.userId)
                game.pasteScore(pasteMyScore: copyMyScore, pasteOtherScore: copyOtherScore)
            }
        }
    }
    
    override func redoit() {
        doit(.redoit)
    }

    override func data (function: CloseItActionData.Function) -> CloseItActionData {
        let actionData = CloseItActionData(function: function, object: obj.type, status: newStatus, x: obj.x, y: obj.y, source: source)
        
        return actionData
    }
}
