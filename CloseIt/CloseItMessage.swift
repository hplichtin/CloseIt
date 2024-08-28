//
//  CloseItMessage.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 03.12.21.
//

import Foundation

class CloseItMessage {
    static var doDebug: Bool = true
    
    func title (severity: String) -> String {
        return "[CloseIt][\(severity)]"
    }
    
    func title (severity: String, function: String) -> String {
        return "[CloseIt][\(severity)][\(function)]"
    }
    
    func title (severity: String, file: StaticString, line: UInt, function: String) -> String {
        return title(severity: severity) + "[FILE:\(file)][LINE: \(line)] \(function):"
    }
    
    func message (severity: String, text: String, file: StaticString, line: UInt, function: String) -> String {
        return title(severity: severity, file: file, line: line, function: function) + " " + text
    }

    func debug (_ text: String, file: StaticString = #file, line: UInt = #line, function: String = #function) {
        if CloseItMessage.doDebug {
            print(message(severity: "DEBUG", text: text, file: file, line: line, function: function))
        }
    }
        
    func warning (_ text: String, file: StaticString = #file, line: UInt = #line, function: String = #function) {
        print(message(severity: "WARNING", text: text, file: file, line: line, function: function))
    }
    
    func error (_ text: String, file: StaticString = #file, line: UInt = #line, function: String = #function) -> Never {
        fatalError(title(severity: "ERROR", function: function) + text, file: file, line: line)
    }

//#if CLOSEIT_LOG
    static var doLog: Bool = true
    var logStack: Int = 0

    func log (_ text: String, file: StaticString = #file, line: UInt = #line, function: String = #function) {
        if CloseItMessage.doLog {
            print(title(severity: "LOG") + "[\(logStack)][\(function)] \(text)")
        }
    }
// #endif
}

var myMessage = CloseItMessage()

//#if CLOSEIT_LOG
func CLOSEIT_FUNC_START (_ text: String = "", file: StaticString = #file, line: UInt = #line, function: String = #function) {
    myMessage.logStack += 1
    myMessage.log("START" + text, file: file, line: line, function: function)
}

func CLOSEIT_TYPE_FUNC_START (_ obj: CloseItLog, _ text: String = "", file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
    CLOSEIT_FUNC_START(text, file: file, line: line, function: "\(obj.className).\(function)")
}
    
func CLOSEIT_FUNC_END (_ text: String = "", file: StaticString = #file, line: UInt = #line, function: String = #function) {
    myMessage.log("END" + text, file: file, line: line, function: function)
    myMessage.logStack -= 1
}

func CLOSEIT_TYPE_FUNC_END (_ obj: CloseItLog, _ text: String = "", file: StaticString = #file, line: UInt = #line, function: String = #function) {
    CLOSEIT_FUNC_END(text, file: file, line: line, function: "\(obj.className).\(function)")
}

/* #else
func CLOSEIT_FUNC_START () {
    // empty
}

func CLOSEIT_METHODE_FUNC_START () {
 // empty
}

func CLOSEIT_FUNC_END () {
    // empty
}
 
func CLOSEIT_CLASS_FUNC_END () {
    // empty
}
#endif
*/
