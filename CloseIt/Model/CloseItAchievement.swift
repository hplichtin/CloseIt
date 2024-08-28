//
//  CloseItDataUserAchievement.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 27.06.2024.
//

import Foundation

struct CloseItAchievementGroup: CloseItLog {
    var level: Level
    var userId: String
    
    var numCompleted = 0
    var num = 0
    
    static func += (lhs: inout CloseItAchievementGroup, _ rhs: CloseItAchievementGroup) {
        CLOSEIT_FUNC_START()
        precondition(lhs.level == rhs.level)
        precondition(lhs.userId == rhs.userId)
        
        lhs.numCompleted += rhs.numCompleted
        lhs.num += rhs.num
        CLOSEIT_FUNC_END()
    }
    
    mutating func reset (level: Level, userId: String) {
        CLOSEIT_TYPE_FUNC_START(self)
        self.level = level
        self.userId = userId
        numCompleted = 0
        num = 0
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    var completed: Bool {
        return num == numCompleted
    }
    
    var score: String {
        let s = "\(numCompleted) of \(num)"
        
        return s
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
        
        s += ( showName ? "level:" : "" ) + "\(level)" + sep
        s += ( showName ? "userId:" : "" ) + "\(userId)" + sep
        s += ( showName ? "numCompleted:" : "" ) + "\(numCompleted)" + sep
        s += ( showName ? "num:" : "" ) + "\(num)"
        return s
    }
}

struct CloseItAchievementGames: CloseItLog {
    var level: Level
    var userId: String

    var numCompleted = 0
    var numPlayed = 0
    var numRestarts: Int = 0
    var numUndos: Int = 0
    var numRedos: Int = 0
    var timePlayed: TimeInterval = 0

    static func += (lhs: inout CloseItAchievementGames, _ rhs: CloseItAchievementGames) {
        CLOSEIT_FUNC_START()
        precondition(lhs.level == rhs.level)
        precondition(lhs.userId == rhs.userId)
        
        lhs.numCompleted += rhs.numCompleted
        lhs.numPlayed += rhs.numPlayed
        lhs.numRestarts += rhs.numRestarts
        lhs.numUndos += rhs.numUndos
        lhs.numRedos += rhs.numRedos
        lhs.timePlayed += rhs.timePlayed
        CLOSEIT_FUNC_END()
    }
    
    static func += (lhs: inout CloseItAchievementGames, _ rhs: CloseItDataScore) {
        CLOSEIT_FUNC_START()
        precondition(lhs.userId == rhs.userId)
        
        if rhs.completed {
            lhs.numCompleted += 1
        }
        lhs.numPlayed += 1
        lhs.timePlayed += rhs.timePlayed
        lhs.numRestarts += rhs.numRestarts
        lhs.numUndos += rhs.numUndos
        lhs.numRedos += rhs.numRedos
        lhs.timePlayed += rhs.timePlayed
        CLOSEIT_FUNC_END()
    }

    mutating func reset (level: Level, userId: String) {
        self.level = level
        self.userId = userId
        numCompleted = 0
        numPlayed = 0
        numRestarts = 0
        numUndos = 0
        numRedos = 0
        timePlayed = 0
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
        
        s += ( showName ? "level:" : "" ) + "\(level)" + sep
        s += ( showName ? "userId:" : "" ) + "\(userId)" + sep
        s += ( showName ? "numCompleted:" : "" ) + "\(numCompleted)" + sep
        s += ( showName ? "numPlayed:" : "" ) + "\(numPlayed)" + sep
        s += ( showName ? "numRestarts:" : "" ) + "\(numRestarts)" + sep
        s += ( showName ? "numUndos:" : "" ) + "\(numUndos)" + sep
        s += ( showName ? "numRedos:" : "" ) + "\(numRedos)" + sep
        s += ( showName ? "timePlayed:" : "" ) + "\(timePlayed)"
        return s
    }
}

enum CloseItAchievementType: String, CaseIterable {
    case numChallengesPlayed = "numChallengesPlayed"
    case numChallengesCompleted = "numChallengesCompleted"
    case allChallengesAtLevelCompleted = "allChallengesAtLevelCompleted"
    case numBoardsPlayed = "numBoardsPlayed"
    case numBoardsCompleted = "numBoardsCompleted"
    case numBoardGroupsCompleted = "numBoardGroupsCompleted"
    case numDaysPlayed = "numDaysPlayed"
}

class CloseItAchievement: CloseItClass, Identifiable {
    var data: CloseItDataAchievement
    var nextUserAchievement: Bool = false
    
    init (userId: String = "", achievementType: CloseItAchievementType, achievementValue: Int) {
        data = CloseItDataAchievement(userId: userId, achievementType: achievementType.rawValue, achievementValue: achievementValue)
    }
    
    init (data: CloseItDataAchievement) {
        self.data = data
    }
    
    init (achievement: CloseItAchievement) {
        self.data = achievement.data
    }
    
    func reset () {
        data.userId = ""
        nextUserAchievement = false
    }
    
    var id: String {
        return data.id
    }
    
    var achieved: Bool {
        return userId != ""
    }
    
    func achieved (userId: String) {
        data.userId = userId
        data.achievementDate = Date()
        nextUserAchievement = false
    }
    
    var achievementType: CloseItAchievementType {
        let at = CloseItAchievementType(rawValue: data.achievementType)
        
        if at == nil {
            myMessage.error("undexpected achievementType '\(data.achievementType)'")
        }
        return at!
    }
    
    var achievementValue: Int {
        return data.achievementValue
    }
    
    var userId: String {
        return data.userId
    }
    
    static func == (lhs: CloseItAchievement, rhs: CloseItAchievement) -> Bool {
        return lhs.id == rhs.id
    }
        
    static func load (objects: inout [CloseItAchievement]) {
        var data: [CloseItDataAchievement] = []
        
        CloseItDataAchievement.load(data: &data)
        for d in data {
            let design = CloseItAchievement(data: d)
            
            objects.append(design)
        }
    }
    
    static func store (objects: [CloseItAchievement]) {
        var data: [CloseItDataAchievement] = []
        
        for o in objects {
            data.append(o.data)
        }
        CloseItDataAchievement.store(data: data)
    }
    
    static func getAchievementTypeName (achievementType: CloseItAchievementType) -> String {
        let achievementTypeName = CloseIt.getLocalizedText(type: "achievementTypeName", id: achievementType.rawValue)
        
        return achievementTypeName
    }
    
    var achievementTypeName: String {
        let achievementTypeName = CloseItAchievement.getAchievementTypeName(achievementType: achievementType)
        
        return achievementTypeName
    }
    
    var badgeImageName: String {
        CLOSEIT_TYPE_FUNC_START(self)
        let imageName: String
        if achievementType == .allChallengesAtLevelCompleted {
            imageName = CloseItDataLevel.type + "." + "\(data.achievementValue)" + ".badge"
        }
        else {
            imageName = data.type + "." + data.achievementType + "." + "\(data.achievementValue)" + ".badge"
        }
        CLOSEIT_TYPE_FUNC_END(self, " -> \(imageName)")
        return imageName
    }
    
    func contains (userId: String, achievement: CloseItAchievement) -> Bool {
        CLOSEIT_TYPE_FUNC_START(self)
        let c = self.userId == userId && achievementType == achievement.achievementType && achievementValue == achievement.achievementValue
 
        CLOSEIT_TYPE_FUNC_END(self)
        return c
    }

    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        return data.value(showName: showName, sep: sep)
    }

    var description: String {
        return "[CloseItAchievement|id:\(id)]"
    }
}

class CloseItAchievements: CloseItClass, ObservableObject {
    var objects: [CloseItAchievement] = []
    
    var count: Int {
        return objects.count
    }
    
    func getNumAchieved (userId: String) -> Int {
        var n = 0
        
        CLOSEIT_TYPE_FUNC_START(self)
        for o in objects {
            if o.achieved && o.userId == userId {
                n += 1
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
        return n
    }
    
    func reset () {
        for o in objects {
            o.reset()
        }
    }
    
    func append (achievement: CloseItAchievement) {
        objects.append(achievement)
    }
    
    func achievedAchievement (index: Int, userId: String) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(index >= 0 && index < count)
        
        objects[index].achieved(userId: userId)
        if index < count - 1 {
            if objects[index].achievementType == objects[index + 1].achievementType {
                objects[index + 1].nextUserAchievement = true
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func contains (userId: String, achievement: CloseItAchievement) -> Int {
        CLOSEIT_TYPE_FUNC_START(self)
        var i = 0

        while i < count {
            let c = objects[i].contains(userId: userId, achievement: achievement)
            if (c) {
                break
            }
            else {
                i += 1
            }
        }

        CLOSEIT_TYPE_FUNC_END(self)
        return i
    }
    
    func numAchievements (userId: String) -> Int {
        var num = 0
        
        for o in objects {
            if o.data.userId == userId {
                num += 1
            }
        }
        return num
    }
        
    func load () {
        var dataAchievements: [CloseItDataAchievement] = []
        
        CloseItDataAchievement.load(data: &dataAchievements)
        for d in dataAchievements {
            let achievement = CloseItAchievement(data: d)
            
            append(achievement: achievement)
        }
    }
    
    func store () {
        var data: [CloseItDataAchievement] = []
        
        for o in objects {
            data.append(o.data)
        }
        CloseItDataAchievement.store(data: data)
    }
}
