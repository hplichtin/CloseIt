//
//  CloseItActionData.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 29.06.2024.
//

import Foundation

class CloseItActionData: Codable {
    enum Function: String {
        case doit = "d"
        case undoit = "u"
    }
    
    enum Source: String {
        case isUserAction = "u", isSelectCell = "c", isAutoAction = "a"
    }
    
    private var functionCode: String
    private var objectCode: String
    private var statusCode: String
    var x: Int
    var y: Int
    private var sourceCode: String
    
    init (function: Function, object: CloseItObject.Object, status: CloseItObject.Status, x: Int, y: Int, source: Source) {
        self.functionCode = function.rawValue
        self.objectCode = object.rawValue
        self.x = x
        self.y = y
        self.statusCode = status.rawValue
        self.sourceCode = source.rawValue
    }
    
    static func encode (dataArray: [CloseItActionData]) -> String {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(dataArray)
        let s = data == nil ? nil : String(data: data!, encoding: .utf8)
        
        return s == nil ? "" : s!
    }
    
    static func decode (encodedStr: String) -> [CloseItActionData] {
        let endocedData = encodedStr.data(using: .utf8)
        let decoder = JSONDecoder()
        
        do {
            let dataArray = try decoder.decode([CloseItActionData].self, from: endocedData!)
            
            return dataArray
        } catch {
            myMessage.error("CloseItActionData.decode('\(encodedStr)' -> \(error)")
        }
    }
    
    var function: Function {
        get {
            if functionCode == Function.doit.rawValue {
                return .doit
            }
            else if functionCode == Function.undoit.rawValue {
                return .undoit
            }
            myMessage.error("CloseItActionData.functionCode '\(functionCode)' unknown")
        }
        set {
            functionCode = newValue.rawValue
        }
    }
    
    var object: CloseItObject.Object {
        get {
            if objectCode == CloseItObject.Object.isCell.rawValue {
                return .isCell
            }
            else if objectCode == CloseItObject.Object.isLineX.rawValue {
                return .isLineX
            }
            else if objectCode == CloseItObject.Object.isLineY.rawValue {
                return .isLineY
            }
            myMessage.error("CloseItActionData.objectCode '\(objectCode)' unknown")
        }
        set {
            objectCode = newValue.rawValue
        }
    }

    
    var status: CloseItObject.Status {
        get {
            if statusCode == CloseItObject.Status.isIn.rawValue {
                return .isIn
            }
            else if statusCode == CloseItObject.Status.isSelected.rawValue {
                return .isSelected
            }
            myMessage.error("CloseItActionData.statusCode '\(functionCode)' unknown")
        }
        set {
            statusCode = newValue.rawValue
        }
    }
    
    var source: Source {
        get {
            if sourceCode == Source.isUserAction.rawValue {
                return .isUserAction
            }
            else if sourceCode == Source.isSelectCell.rawValue {
                return .isSelectCell
            }
            else if sourceCode == Source.isAutoAction.rawValue {
                return .isAutoAction
            }
            myMessage.error("CloseItActionData.sourceCode '\(sourceCode)' unknown")
        }
        set {
            sourceCode = newValue.rawValue
        }
    }
}
