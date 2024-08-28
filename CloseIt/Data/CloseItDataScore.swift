//
//  CloseItDataScore.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 02.12.21.
//

import Foundation
import Combine

struct CloseItDataScore: Hashable, Codable, Identifiable, Equatable, Comparable, CustomStringConvertible {
    static let type = "score"
    static let version = "v1"
    static let scoreSep: String.Element = "x"
    static let scoreAll: String = "*"
    static let scoreAllNum: Int = -1
    
    var program: String
    var type: String
    var version: String
    var id: UUID
    var userId: String
    var gameId: UUID
    var boardId: String
    private var boardName: String // can be deleted
    var numSelectedCells: Int
    var numSelectableCells: Int
    var maxStreakCount: Int
    var numSelectedLinesX: Int
    var numSelectedLinesY: Int
    var numRestarts: Int
    var numUndos: Int
    var numRedos: Int
    var won: Bool
    var target: String
    var challenge: String
    var level: Level
    var completed: Bool
    var startTimestamp = Date()
    var endTimestamp = Date()
    
    static func == (lhs: CloseItDataScore, rhs: CloseItDataScore) -> Bool {
        /*        return lhs.userId == rhs.userId && lhs.boardId == rhs.boardId && lhs.boardName == rhs.boardName && lhs.numSelectedCells == rhs.numSelectedCells && lhs.numSelectableCells == rhs.numSelectableCells && lhs.maxStreakCount == rhs.maxStreakCount && lhs.maxNumSelectedLinesXNotAtSelectedCells == rhs.maxNumSelectedLinesXNotAtSelectedCells && lhs.maxNumSelectedLinesYNotAtSelectedCells == rhs.minMaxNumSelectedLinesXYNotAtSelectedCells &&  lhs.won == rhs.won && lhs.challenge == rhs.challenge && lhs.completed == rhs.completed && lhs.startTimestamp == rhs.startTimestamp && lhs.endTimestamp == rhs.endTimestamp
         */
        return lhs.userId == rhs.userId && lhs.gameId == rhs.gameId && lhs.startTimestamp == rhs.startTimestamp && lhs.endTimestamp == rhs.endTimestamp
    }

    static func < (lhs: CloseItDataScore, rhs: CloseItDataScore) -> Bool {
        if lhs.boardId < rhs.boardId {
            return true
        }
        if lhs.boardId > rhs.boardId {
            return false
        }
        if lhs.numSelectedCells > rhs.numSelectedCells {
            return true
        }
        if lhs.numSelectedCells < rhs.numSelectedCells {
            return false
        }
        if lhs.maxStreakCount > rhs.maxStreakCount {
            return true
        }
        if lhs.maxStreakCount < rhs.maxStreakCount {
            return false
        }
        if lhs.numSelectedLines < rhs.numSelectedLines {
            return true
        }
        if lhs.numSelectedLines > rhs.numSelectedLines {
            return false
        }
        if lhs.minNumSelectedLinesXY > rhs.minNumSelectedLinesXY {
            return true
        }
        if lhs.minNumSelectedLinesXY < rhs.minNumSelectedLinesXY {
            return false
        }
        if lhs.startTimestamp.distance(to: lhs.endTimestamp) < rhs.startTimestamp.distance(to: rhs.endTimestamp) {
            return true
        }
        if lhs.startTimestamp.distance(to: lhs.endTimestamp) > rhs.startTimestamp.distance(to: rhs.endTimestamp) {
            return false
        }
        if lhs.startTimestamp < rhs.startTimestamp {
            return true
        }
        return false
    }
    
    static func load (url: URL, data: inout [CloseItDataScore]) {
        let loadedData: Data? = CloseItData.load(url: url)
        
        if loadedData != nil {
            let d: [CloseItDataScore] = loadCloseItData(data: loadedData!)
            
            data += d
        }
    }
    
    static func load (data: inout [CloseItDataScore]) {
        let url: URL = CloseItData.getURL(userDomainFileName: type  + "-" + version)
        
        load(url: url, data: &data)
    }
    
    static func store (url: URL, data: [CloseItDataScore]) {
        storeCloseItData(t: data, url: url)
    }

    static func store (data: [CloseItDataScore]) {
        storeCloseItData(t: data, userDomainFileName: type  + "-" + version)
    }

    init(program: String = CloseIt.program,
         type: String = CloseItDataScore.type,
         version: String = CloseItDataScore.version,
         userId: String,
         gameId: UUID,
         boardId: String,
         boardName: String,
         numSelectableCells: Int,
         target: String,
         challenge: String,
         level: Level) {
        self.program = program
        self.type = type
        self.version = version
        self.id = UUID()
        self.userId = userId
        self.gameId = gameId
        self.boardId = boardId
        self.boardName = boardName
        self.numSelectedCells = 0
        self.numSelectableCells = numSelectableCells
        self.maxStreakCount = 0
        self.numSelectedLinesX = 0
        self.numSelectedLinesY = 0
        self.numRestarts = 0
        self.numUndos = 0
        self.numRedos = 0
        self.won = false
        self.target = target
        self.challenge = challenge
        self.level = level
        self.completed = false
    }
    
    init (data: CloseItDataScore) {
        self = data
        id = UUID()
    }

    var scoreId: String {
        return "\(numSelectedCells)\(CloseItDataScore.scoreSep)\(maxStreakCount)\(CloseItDataScore.scoreSep)\(numSelectedLines)\(CloseItDataScore.scoreSep)\(minNumSelectedLinesXY)"
    }
    
    var isChallenge: Bool {
        return challenge != ""
    }
    
    var isBoard: Bool {
        return challenge == ""
    }
    
    func hasScore () -> Bool {
        return numSelectedCells > 0 || numSelectedLines > 0 || numSelectedLines > 0 || numUndos > 0 || numRedos > 0 || numRestarts > 0
    }
    
    mutating func start () {
        if !hasScore() {
            startTimestamp = Date()
        }
    }
    
    var numSelectedLines: Int {
        return numSelectedLinesX + numSelectedLinesY
    }
    
    var minNumSelectedLinesXY: Int {
        return min(numSelectedLinesX, numSelectedLinesY)
    }
    
    mutating func reset () {
        // id = UUID()
        numSelectedCells = 0
        maxStreakCount = 0
        numSelectedLinesX = 0
        numSelectedLinesY = 0
        won = false
        completed = false
        // startTimestamp = Date()
    }
    
    struct Score {
        var numSelectedCells: Int = 0
        var maxStreakCount: Int = 0
        var numSelectedLines: Int = 0
        var minNumSelectedLinesXY: Int = 0
    }
    
    var currentScoreStr: String {
        var score: String
        
        score = "\(numSelectedCells)" + "\(CloseItDataScore.scoreSep)" + "\(maxStreakCount)" + "\(CloseItDataScore.scoreSep)" + "\(numSelectedLines)" + "\(CloseItDataScore.scoreSep)" + "\(minNumSelectedLinesXY)"
        return score
    }

    var currentScoreData: Score {
        var score = Score()
        
        score.numSelectedCells = numSelectedCells
        score.maxStreakCount = maxStreakCount
        score.numSelectedLines = numSelectedLines
        score.minNumSelectedLinesXY = minNumSelectedLinesXY
        return score
    }
    
    static func getScore (goal: String) -> Score {
        var score = Score()
        
        if goal != "" {
            let numValues = 4
            var c = goal
            var strValues: [String] = ["", "", "", ""]
            
            for i in 0..<numValues {
                let sep = c.firstIndex(of: CloseItDataScore.scoreSep) ?? c.endIndex
                
                strValues[i] = String(c[..<sep])
                if sep != c.endIndex {
                    c.removeSubrange(...sep)
                }
            }
            score.numSelectedCells = strValues[0] != CloseItDataScore.scoreAll ? Int(strValues[0])! : CloseItDataScore.scoreAllNum
            score.maxStreakCount = strValues[1] != CloseItDataScore.scoreAll ? Int(strValues[1])! : CloseItDataScore.scoreAllNum
            score.numSelectedLines = strValues[2] != CloseItDataScore.scoreAll ? Int(strValues[2])! : CloseItDataScore.scoreAllNum
            score.minNumSelectedLinesXY = strValues[3] != CloseItDataScore.scoreAll ? Int(strValues[3])! :  CloseItDataScore.scoreAllNum
        }
        else {
            score.numSelectedCells = CloseItDataScore.scoreAllNum
            score.maxStreakCount = CloseItDataScore.scoreAllNum
            score.numSelectedLines = CloseItDataScore.scoreAllNum
            score.minNumSelectedLinesXY = CloseItDataScore.scoreAllNum
        }
        return score
    }
    
    var targetScore: Score {
        return CloseItDataScore.getScore(goal: target)
    }
    
    var challengeScore: Score {
        return CloseItDataScore.getScore(goal: challenge)
    }
    
    func isCompleted () -> Bool {
        var score: Score
        
        if target != "" {
            score = targetScore
        }
        else if challenge != "" {
            score = challengeScore
        }
        else {
            return maxStreakCount == numSelectableCells
        }
        if score.numSelectedCells != CloseItDataScore.scoreAllNum {
            if numSelectedCells != score.numSelectedCells {
                return false
            }
        }
        if score.maxStreakCount != CloseItDataScore.scoreAllNum {
            if maxStreakCount != score.maxStreakCount {
                return false
            }
        }
        if score.numSelectedLines != CloseItDataScore.scoreAllNum {
            if numSelectedLines != score.numSelectedLines {
                return false
            }
        }
        if score.minNumSelectedLinesXY != CloseItDataScore.scoreAllNum {
            if minNumSelectedLinesXY != score.minNumSelectedLinesXY {
                return false
            }
        }
        return true
    }
    
    mutating func done (won: Bool) {
        endTimestamp = Date()
        self.won = won
        self.completed = isCompleted()
    }
    
    var timePlayed: TimeInterval {
        return startTimestamp.distance(to: endTimestamp)
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
     
        s += ( showName ? "program:" : "" ) + program + sep
        s += ( showName ? "type:" : "" ) + type + sep
        s += ( showName ? "version:" : "" ) + version + sep
        s += ( showName ? "id:" : "" ) + "\(id)" + sep
        s += ( showName ? "userId:" : "" ) + "\(userId)" + sep
        s += ( showName ? "gameId:" : "" ) + "\(gameId)" + sep
        s += ( showName ? "boardId:" : "" ) + boardId + sep
        s += ( showName ? "boardName:" : "" ) + boardName + sep
        s += ( showName ? "numSelectedCells:" : "" ) + "\(numSelectedCells)" + sep
        s += ( showName ? "numSelectableCells:" : "" ) + "\(numSelectableCells)" + sep
        s += ( showName ? "maxStreakCount:" : "" ) + "\(maxStreakCount)" + sep
        s += ( showName ? "maxNumSelectedLinesX:" : "" ) + "\(numSelectedLinesX)" + sep
        s += ( showName ? "maxNumSelectedLinesY:" : "" ) + "\(numSelectedLinesY)" + sep
        s += ( showName ? "numRestarts:" : "" ) + "\(numRestarts)" + sep
        s += ( showName ? "numUndos:" : "" ) + "\(numUndos)" + sep
        s += ( showName ? "numRedos:" : "" ) + "\(numRedos)" + sep
        s += ( showName ? "won:" : "" ) + "\(won)" + sep
        s += ( showName ? "target:" : "" ) + target + sep
        s += ( showName ? "challenge:" : "" ) + challenge + sep
        s += ( showName ? "level:" : "" ) + "\(level)" + sep
        s += ( showName ? "completed:" : "" ) + "\(completed)" + sep
        s += ( showName ? "startTimestamp:" : "" ) + "\(startTimestamp)" + sep
        s += ( showName ? "endTimestamp:" : "" ) + "\(endTimestamp)"
        return s
    }
    
    var description: String {
        return "[CloseItDataScore|id:\(id)]"
    }
}
