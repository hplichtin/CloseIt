//
//  CloseItObjectTable.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import Foundation

class CloseItObjectTable: RandomAccessCollection {
    var objs: [CloseItObjectArray]
    
    init () {
        objs = []
    }
    
    init (sizeX: Int, sizeY: Int, type: CloseItObject.Object, status: CloseItObject.Status, userId: String? = nil) {
        var x: Int = 0
        objs = []
        
        while x < sizeX {
            objs.append(CloseItObjectArray(x: x, sizeY: sizeY, type: type, status: status, userId: userId))
            x += 1
        }
    }
    
    init (sizeX: Int, sizeY: Int, type: CloseItObject.Object, statusStr: String, userId: String? = nil) {
        var x: Int = 0
        var s = statusStr
        objs = []

        while x < sizeX {
            while s.count > 0 && s[s.startIndex] == " " {
                s.remove(at: s.startIndex)
            }
            
            let range = s.startIndex..<s.index(s.startIndex, offsetBy: sizeY)

            objs.append(CloseItObjectArray(x: x, sizeY: sizeY, type: type, statusStr: s, userId: userId))
            s.removeSubrange(range)
            x += 1
        }
    }
    
    init (table: CloseItObjectTable) {
        objs = []
        for o in table.objs {
            objs.append(CloseItObjectArray(array: o))
        }
    }
    
    var startIndex: Int {
        return objs.startIndex
    }
    
    var endIndex: Int {
        return objs.endIndex
    }
    
    subscript(x: Int) -> CloseItObjectArray {
        return objs[x]
    }
    
    subscript(x: Int, y: Int) -> CloseItObject {
        return objs[x][y]
    }
    
    var count: Int {
        return objs.count
    }
    
    func append (array: CloseItObjectArray) {
        self.objs.append(array)
    }
    
    func reset () {
        for o in objs {
            o.reset()
        }
    }
    
    func copy (table: CloseItObjectTable) {
        var i: Int = 0
        
        while i < count && i < table.count {
            objs[i].copy(array: table[i])
            i += 1
        }
        while i < count {
            objs.removeLast()
            i += 1
        }
        while i < table.count {
            append(array: CloseItObjectArray(array: table[i]))
            i += 1
        }
    }
    
    func selectedOrBorder () -> Int {
        var s = 0
        
        for o in objs {
            s += o.selectedOrBorder()
        }
        return s
    }
    
    func selectedOrBorder (userId: String) -> Int {
        var s = 0
        
        for o in objs {
            s += o.selectedOrBorder(userId: userId)
        }
        return s
    }
    
    func areAllCellsSelected () -> Bool {
        for o in objs {
            if !o.areAllCellsSelected() {
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

    func str(arraySep: String = "", objSep: String = "") -> String {
        var s: String = ""
        var i: Int = 0
        for o in objs {
            s += "[\(i):" + o.str(objSep: objSep) + "]" + arraySep
            i += 1
        }
        return s
    }
}
    
