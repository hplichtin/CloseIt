//
//  CloseItActionArray.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 17.09.22.
//

import Foundation

class CloseItActionArray: RandomAccessCollection {
    struct ActionData {
        var action: CloseItAction
        var function: CloseItActionData.Function
    }
    
    private var _actions: [ActionData]
    
    init () {
        _actions = []
    }
    
    func reset () {
        _actions = []
    }
    
    subscript(i: Int) -> CloseItAction {
        return _actions[i].action
    }
    
    var actionData: [ActionData] {
        return _actions
    }
    
    var count: Int {
        return _actions.count
    }
    
    var startIndex: Int {
        return _actions.startIndex
    }
    
    var endIndex: Int {
        return _actions.endIndex
    }
    
    func append (action: CloseItAction, function: CloseItActionData.Function) {
        let data = ActionData(action: action, function: function)
        
        _actions.append(data)
    }
   
    func removeAll () {
        _actions.removeAll()
    }
    
    func removeLast () {
        _actions.removeLast()
    }
    
    var last: CloseItAction {
        if count == 0 {
            abort()
        }
        return _actions.last!.action
    }
    
    func data () -> [CloseItActionData] {
        var actionsData: [CloseItActionData] = []
        
        for a in _actions {
            actionsData.append(a.action.data(function: a.function))
        }
        return actionsData
    }

    func data () -> String {
        let actionsData: [CloseItActionData] = data()
        let s = CloseItActionData.encode(dataArray: actionsData)

        return s
    }
 }
