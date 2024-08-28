//
//  CloseItGameActions.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 17.09.22.
//

import Foundation

class CloseItGameActions {
    var id: UUID

    private var actionsLog: CloseItActionArray = CloseItActionArray()
    private var undoActionsStack: CloseItActionArray = CloseItActionArray()
    private var redoActionsStack: CloseItActionArray = CloseItActionArray()
    
    private var nextAction = 0
    
    init () {
        id = UUID()
    }
    
    var canUndo: Bool {
        return undoActionsStack.count > 0
    }
    
    var canRedo: Bool {
        return redoActionsStack.count > 0
    }

    func reset () {
        actionsLog.reset()
        undoActionsStack.reset()
        redoActionsStack.reset()
    }
    
    func doNext () {
        var source: CloseItActionData.Source = .isUserAction
        
        while nextAction < actionsLog.count {
            let action = actionsLog[nextAction]
            
            action.doit()
            nextAction += 1
            if !action.isPlay || source == .isAutoAction && action.source == .isUserAction {
                break
            }
            if nextAction < actionsLog.count {
                let next = actionsLog[nextAction]
                
                if action.getFunction() != next.getFunction() || next.getFunction() == .doit && next.source == .isUserAction || next.getFunction() == .undoit && source == .isUserAction && next.source == .isUserAction {
                    break
                }
            }
            source = .isAutoAction
            action.sleep()
        }
    }
    
    func doAll () {
        var isPlay = true
        
        repeat {
            doNext()
            if nextAction < actionsLog.count {
                isPlay = actionsLog[nextAction].isPlay
                if isPlay {
                    actionsLog[nextAction].sleep()
                }
            }
        } while nextAction < actionsLog.count && isPlay
    }
    
    func doPrevious () {
        while nextAction > 0 {
            let action = actionsLog[nextAction - 1]
            
            nextAction -= 1
            action.undoit()
            if !action.isPlay || action.getFunction() == .doit && action.source == .isUserAction {
                break
            }
            if nextAction > 0 {
                let previous = actionsLog[nextAction - 1]
                
                if action.getFunction() != previous.getFunction() || action.getFunction() == .undoit && previous.source == .isUserAction {
                    break
                }

            }
            actionsLog[nextAction].sleep()
        }
    }
    
    func undoAll () {
        var isPlay = true

        repeat {
            doPrevious()
            if nextAction > 0 {                
                isPlay = actionsLog[nextAction].isPlay
                if isPlay {
                    actionsLog[nextAction].sleep()
                }
            }
        } while nextAction > 0 && isPlay
    }
    
    var isFirstAction: Bool {
        return nextAction == 0
    }

    var isLastAction: Bool {
        return nextAction >= actionsLog.count
    }
    
    func addActionToLog (action: CloseItAction, function: CloseItActionData.Function) {
        actionsLog.append(action: action, function: function)
    }
    
    func doit (action: CloseItAction) {
        actionsLog.append(action: action, function: .doit)
        nextAction = actionsLog.count
        if action.canUndo {
            undoActionsStack.append(action: action, function: .doit)
        }
        else {
            undoActionsStack.removeAll()
        }
        redoActionsStack.removeAll()
        action.doit()
    }
    
    func undoit () {
        while undoActionsStack.count > 0 {
            let action = undoActionsStack.last
            
            if action.canUndo {
                actionsLog.append(action: action, function: .undoit)
                undoActionsStack.removeLast()
                redoActionsStack.append(action: action, function: .undoit)
                action.undoit()
                if action.source == .isUserAction || (action.source == .isAutoAction && !action.isPlay) {
                    return
                }
                action.sleep()
            }
            else {
                undoActionsStack.removeAll()
                redoActionsStack.removeAll()
            }
        }
    }
    
    func redoit () {        
        while redoActionsStack.count > 0 {
            var action = redoActionsStack.last

            actionsLog.append(action: action, function: .doit)
            action.redoit()
            if action.canUndo {
                undoActionsStack.append(action: action, function: .doit)
            }
            else {
                undoActionsStack.removeAll()
            }
            if redoActionsStack.count > 0 {
                redoActionsStack.removeLast()
                if redoActionsStack.count > 0 {
                    action = redoActionsStack.last
                    if action.source == .isUserAction || (action.source == .isAutoAction && !action.isPlay) {
                        return
                    }
                }
            }
        }
    }
    
    func logData () -> String {
        return actionsLog.data()
    }
}
