//
//  CloseItLevels.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 10.07.2024.
//

import Foundation

class CloseItLevel: CloseItClass, Identifiable {
    private var data: CloseItDataLevel
    
    init (data: CloseItDataLevel) {
        self.data = data
    }
    
    var id: Level {
        return data.id
    }
    
    var level: Int {
        return data.level
    }
    
    var levelName: String {
        let name = getLocalizedText(type: data.type + ".levelName", id: "\(id)")
        return name
    }
    
    var levelDescription: String {
        let description = getLocalizedText(type: data.type + ".levelDescription", id: "\(id)")
        return description
    }
    
    var badgeImageName: String {
        let imageName = data.type + "." + "\(level)" + ".badge"
        return imageName
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        let s = data.value(showName: showName, sep: sep)
        
        return s
    }
}

class CloseItLevels: CloseItClass {
    var levels: [CloseItLevel] = []
    
    var count: Int {
        return levels.count
    }
    
    func append (level: CloseItLevel) {
        levels.append(level)
    }
    
    func getLevel (level: Level) -> CloseItLevel {
        CLOSEIT_TYPE_FUNC_START(self)
        
        var i = 0
        while i < levels.count {
            if level == levels[i].id {
                CLOSEIT_TYPE_FUNC_END(self)
                return levels[i]
            }
            i += 1
        }
        myMessage.error("unepected level '\(level)")
    }

    func getMaxLevel () -> CloseItLevel {
        CLOSEIT_TYPE_FUNC_START(self)
        var i = 0
        var max = 0
        var maxI = 0
        
        while i < levels.count {
            if max < levels[i].level {
                maxI = i
                max = levels[i].level
            }
            i += 1
        }
        CLOSEIT_TYPE_FUNC_END(self)
        return levels[maxI]
    }
    
    func load () {
        var dataLevels: [CloseItDataLevel] = []
        
        CloseItDataLevel.load(data: &dataLevels)
        for d in dataLevels {
            append(level: CloseItLevel(data: d))
        }
    }
}
