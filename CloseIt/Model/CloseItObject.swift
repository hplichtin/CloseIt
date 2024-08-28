//
//  CloseItObject.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import Foundation

class CloseItObject: Identifiable, ObservableObject {
    // Types
    enum Object: String {
        case isCell = "c", isLineX = "x", isLineY = "y"
    }
    
    static func name (type: Object) -> String {
        switch type {
        case .isCell:
            return "cell"
        case .isLineX:
            return "linex"
        case .isLineY:
            return "liney"
        }
    }

    // Status
    enum Status: String {
        case isOut = "O", isIn = "I", isSelected = "S", isBorder = "B"
    }
    
    static func value (status: Status) -> Character {
        let s = status.rawValue
        
        return s[s.startIndex]
    }
    
    static func name (status: Status) -> String {
         switch status {
         case .isOut:
             return "out"
         case .isIn:
             return "in"
         case .isSelected:
             return "selected"
         case .isBorder:
             return "border"
         }
     }
    
    static let defaultStatus: Status = .isOut
    
    static func statusFromStr (statusStr: String) -> Status {
        if statusStr.isEmpty {
            return .isOut
        }
        switch statusStr[statusStr.startIndex] {
        case CloseItObject.value(status: .isOut):
            return .isOut
        case CloseItObject.value(status: .isIn):
            return .isIn
        case CloseItObject.value(status: .isSelected):
            return .isSelected
        case CloseItObject.value(status: .isBorder):
            return .isBorder
        default:
            return defaultStatus
        }
    }
    
    private static func getDefaultSelectable (type: Object, status: Status) -> Bool {
        return type != .isCell ? status == .isIn || status == .isSelected : false
    }

    var id: UUID
    
    private var _type: Object
    @Published private var _status: Status
    private var _x, _y: Int
    @Published private var _isSelectable: Bool

    private var _userId: String?
        
    init (x: Int, y: Int, type: Object, status: Status, userId: String? = nil) {
        id = UUID()
        _x = x
        _y = y
        _type = type
        _status = status
        _isSelectable = CloseItObject.getDefaultSelectable(type: type, status: status)
        _userId = userId
    }
    
    init (x: Int, y: Int, type: Object, statusStr: String, userId: String? = nil) {
        let status = CloseItObject.statusFromStr(statusStr: statusStr)
        
        id = UUID()
        _x = x
        _y = y
        _type = type
        _status = status
        _isSelectable = CloseItObject.getDefaultSelectable(type: type, status: status)
        _userId = userId
    }
    
    init (obj: CloseItObject) {
        id = UUID()
        _x = obj._x
        _y = obj._y
        _type = obj._type
        _status = obj._status
        _isSelectable = obj._isSelectable
        _userId = obj._userId
    }
    
    func copy (obj: CloseItObject) {
        _x = obj._x
        _y = obj._y
        _type = obj._type
        _status = obj._status
        _isSelectable = obj._isSelectable
        _userId = obj._userId
    }

    func set (status: Status, userId: String? = nil) {
        _status = status
        _isSelectable = CloseItObject.getDefaultSelectable(type: type, status: status)
        _userId = userId
    }
    
    var type: Object {
        return _type
    }
    
    var status: Status {
        return _status
    }
    
    var userId: String? {
        return _userId
    }
    
    func getStatus () -> String {
        return status.rawValue
    }

    func getIsSelectable () -> String {
        return isSelectable ? "s": "-"
    }

    func reset () {
        if _status == .isSelected {
           _status = .isIn
        }
        isSelectable = CloseItObject.getDefaultSelectable(type: _type, status: _status)
    }
    
    var isCell: Bool {
        return _type == .isCell
    }
    
    var isLineX: Bool {
        return _type == .isLineX
    }
    
    var isLineY: Bool {
        return _type == .isLineY
    }
    
    var isLine: Bool {
        return isLineX || isLineY
    }
    
    var isSelectedOrBorder: Int {
        if isCell {
            return (status == .isSelected ? 1 : 0)
        }
        if isLine {
            return (status == .isSelected || status == .isBorder ? 1 : 0)
        }
        return 0
    }
    
    func isSelectedOrBorder (userId: String) -> Int {
        if _userId == nil {
            return 0
        }
        if _userId! == userId {
            return isSelectedOrBorder
        }
        return 0
    }
    
    var isSelected: Bool {
        return status == .isSelected
    }
    
    var isSelectable: Bool {
        get {
            return _isSelectable
        }
        set {
            if _isSelectable != newValue {
                _isSelectable = newValue
            }
        }
    }
    
    var isIn: Bool {
        return status == .isIn
    }
    
    var isOut: Bool {
        return status == .isOut
    }
    
    var x: Int {
        return _x
    }
    
    var y: Int {
        return _y
    }
    
    func getImageName (design: CloseItDesign) -> String {
        switch _type {
        case .isCell:
            switch status {
            case .isOut: return design.data.imageCellOut
            case .isIn: return design.data.imageCellIn
            case .isSelected: return design.data.imageCellSelected
            case .isBorder: abort()
            }
        case .isLineX:
            switch status {
            case .isOut: return design.data.imageLineXOut
            case .isIn: return design.data.imageLineXIn
            case .isBorder: return design.data.imageLineXBorder
            case .isSelected: return design.data.imageLineXSelected
            }
        case .isLineY:
            switch status {
            case .isOut: return design.data.imageLineYOut
            case .isIn: return design.data.imageLineYIn
            case .isBorder: return design.data.imageLineYBorder
            case .isSelected: return design.data.imageLineYSelected
            }
        }
    }
    
    static let strCellOut = "O"
    static let strCellIn = " "
    static let strCellSelected = "X"
    static let strLineXOut = " "
    static let strLineXIn = "-"
    static let strLineXBorder = "="
    static let strLineXSelected = "#"
    static let strLineYOut = " "
    static let strLineYIn =  CloseIt.separator
    static let strLineYBorder = "$"
    static let strLineYSelected = "#"

    func str () -> String {
        switch _type {
        case .isCell:
            switch status {
            case .isOut: return CloseItObject.strCellOut
            case .isIn: return CloseItObject.strCellIn
            case .isSelected: return CloseItObject.strCellSelected
            case .isBorder: abort()
            }
        case .isLineX:
            switch status {
            case .isOut: return CloseItObject.strLineXOut
            case .isIn: return CloseItObject.strLineXIn
            case .isBorder: return CloseItObject.strLineXBorder
            case .isSelected: return CloseItObject.strLineXSelected
            }
        case .isLineY:
            switch status {
            case .isOut: return CloseItObject.strLineYOut
            case .isIn: return CloseItObject.strLineYIn
            case .isBorder: return CloseItObject.strLineYBorder
            case .isSelected: return CloseItObject.strLineXSelected
            }
        }
    }
    
    func data () -> String {
        return _type.rawValue + "\(x):\(y)"
    }
}
