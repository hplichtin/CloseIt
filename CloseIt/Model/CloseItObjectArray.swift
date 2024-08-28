//
//  CloseItObjectArray.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import Foundation

class CloseItObjectArray: RandomAccessCollection, Identifiable {
    var objs: [CloseItObject]
    
    init () {
        objs = []
    }
    
    init (x: Int, sizeY: Int, type: CloseItObject.Object, status: CloseItObject.Status, userId: String?) {
        var y: Int = 0
        
        objs = []
        while y < sizeY {
            objs.append(CloseItObject(x: x, y: y, type: type, status: status, userId: userId))
            y += 1
        }
    }
    
    init (x: Int, sizeY: Int, type: CloseItObject.Object, statusStr: String, userId: String?) {
        var y: Int = 0
        var s = statusStr
        
        objs = []
        while y < sizeY {
            objs.append(CloseItObject(x: x, y: y, type: type, statusStr: s, userId: userId))
            s.remove(at: s.startIndex)
            y += 1
        }
    }
    
    init (array: CloseItObjectArray) {
        objs = []
        for o in array.objs {
            objs.append(CloseItObject(obj: o))
        }
    }
    
    subscript(y: Int) -> CloseItObject {
        return objs[y]
    }
    
    var count: Int {
        return objs.count
    }
    
    var startIndex: Int {
        return objs.startIndex
    }
    
    var endIndex: Int {
        return objs.endIndex
    }
    
    func append (obj: CloseItObject) {
        objs.append(obj)
    }
    
    func reset () {
        for o in objs {
            o.reset()
        }
    }
    
    func copy (array: CloseItObjectArray) {
        var i: Int = 0
        
        while i < count && i < array.count {
            objs[i].copy(obj: array[i])
            i += 1
        }
        while i < count {
            objs.removeLast()
            i += 1
        }
        while i < array.count {
            append(obj: CloseItObject(obj: array[i]))
            i += 1
        }
    }
    
    func selectedOrBorder () -> Int {
        var s = 0
        
        for o in objs {
            s += o.isSelectedOrBorder
        }
        return s
    }

    func selectedOrBorder (userId: String) -> Int {
        var s = 0
        
        for o in objs {
            s += o.isSelectedOrBorder(userId: userId)
        }
        return s
    }
    
    func areAllCellsSelected () -> Bool {
        for o in objs {
            if o.isIn {
                return false
            }
        }
        return true
    }
    
    func getStatus () -> String {
        var s = ""
        
        for o in objs {
            s += o.getStatus()
        }
        return s
    }
    
    func getIsSelectable () -> String {
        var s = ""
        
        for o in objs {
            s += o.getIsSelectable()
        }
        return s
    }


    func str(objSep: String = "") -> String {
        var s: String = ""
        for o in objs {
            s += o.str() + objSep
        }
        return s
    }
}

