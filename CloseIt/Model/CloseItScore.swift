//
//  CloseItGameUser.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import Foundation

class CloseItScore: CloseItClass, ObservableObject, Identifiable, Comparable {
    
    @Published var data: CloseItDataScore
    
    var groupRank: Int
    var scoreRank: Int
    var currentStreakCount: Int
    
    var game: CloseItGame? = nil
    @Published var isGameStored = false
        
    static func == (lhs: CloseItScore, rhs: CloseItScore) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func compare (lhs: CloseItScore, rhs: CloseItScore) -> Bool {
        return lhs.data == rhs.data /* && lhs.groupRank == rhs.groupRank &&  lhs.scoreRank == rhs.scoreRank && lhs.currentStreakCount == rhs.currentStreakCount && lhs.currentNumSelectedLinesXNotAtSelectedCells == rhs.currentNumSelectedLinesXNotAtSelectedCells && lhs.currentNumSelectedLinesYNotAtSelectedCells == rhs.currentNumSelectedLinesYNotAtSelectedCells */
    }

    static func < (lhs: CloseItScore, rhs: CloseItScore) -> Bool {
        return lhs.data < rhs.data
    }
    
    static func append (from: [CloseItScore], to: inout [CloseItScore], onlyHasScore: Bool) {
        for f in from {
            if !onlyHasScore || f.hasScore() {
                to.append(CloseItScore(score: f))
            }
        }
    }
    
    static func copy (from: [CloseItScore], to: inout [CloseItScore]) {
        var i = 0
        
        while i < from.count && i < to.count {
            to[i].copy(score: from[i])
            i += 1
        }
        while i < from.count {
            to.append(CloseItScore(score: from[i]))
            i += 1
        }
        while i < to.count {
            to.removeLast()
            i += 1
        }
    }
    
    static func load (objects: inout [CloseItScore]) {
        var data: [CloseItDataScore] = []
        
        CloseItDataScore.load(data: &data)
        for d in data {
            let score = CloseItScore(data: d)
            
            objects.append(score)
        }
    }

    static func store (objects: [CloseItScore]) {
        var data: [CloseItDataScore] = []
        
        for o in objects {
            if o.data.hasScore() {
                data.append(o.data)
            }
        }
        CloseItDataScore.store(data: data)
    }

    init (userId: String,
          gameId: UUID,
          boardId: String,
          boardName: String,
          numSelectableCells: Int,
          target: String,
          challenge: String,
          level: Level) {
        self.data = CloseItDataScore(userId: userId, gameId: gameId, boardId: boardId, boardName: boardName, numSelectableCells: numSelectableCells, target: target, challenge: challenge, level: level)
        self.groupRank = 0
        self.scoreRank = 0
        self.currentStreakCount = 0
    }
    
    init (game: CloseItGame) {
        data = CloseItDataScore(userId: game.userId, gameId: game.id, boardId: game.board.boardId, boardName: game.board.boardName, numSelectableCells: game.board.numSelectableCells(), target: game.board.target, challenge: game.board.challenge, level: game.board.level)
        self.groupRank = 0
        self.scoreRank = 0
        self.currentStreakCount = 0
    }
    
    init (data: CloseItDataScore) {
        self.data = CloseItDataScore(data: data)
        self.groupRank = 0
        self.scoreRank = 0
        self.currentStreakCount = 0
    }
    
    init (score: CloseItScore) {
        data = CloseItDataScore(data: score.data)
        groupRank = score.groupRank
        scoreRank = score.scoreRank
        currentStreakCount = score.currentStreakCount
    }
    
    func copy (score: CloseItScore, withoutRestartsUndosReods: Bool = false) {
        let numRestarts = data.numRestarts
        let numUndos = data.numUndos
        let numRedos = data.numRedos
        data = CloseItDataScore(data: score.data)
        if withoutRestartsUndosReods {
            data.numRestarts = numRestarts
            data.numUndos = numUndos
            data.numRedos = numRedos
        }
        groupRank = score.groupRank
        scoreRank = score.scoreRank
        currentStreakCount = score.currentStreakCount
    }
    
    var id: UUID {
        return data.id
    }
    
    var scoreId: String {
        return data.scoreId
    }

    var won: Bool {
        return data.won
    }

    var isChallenge: Bool {
        return data.isChallenge
    }
    
    var isBoard: Bool {
        return data.isBoard
    }
    
    var completed: Bool {
        return data.completed
    }
    
    var boardId: String {
        return data.boardId
    }

    var boardName: String {
        let name = CloseItBoard.getBoardName(boardId: boardId)
        return name
    }

    var userId: String {
        get {
            return data.userId
        }
        set {
            data.userId = newValue
        }
    }
    
    var gameId: UUID {
        get {
            return data.gameId
        }
        set {
            data.gameId = newValue
        }
    }
    
    var challenge: String {
        return data.challenge
    }
    
    var startTimestamp: Date {
        return data.startTimestamp
    }
    
    var endTimestamp: Date {
        return data.endTimestamp
    }
    
    var timePlayed: TimeInterval {
        return data.timePlayed
    }
        
    var timePlayedAsStr: String {
        let s = CloseIt.timeIntervalAsString(timeInterval: timePlayed)
        
        return s
    }
    
    var numSelectedCells: Int {
        return data.numSelectedCells
    }
    
    var numSelectableCells: Int {
        return data.numSelectableCells
    }
    
    var maxStreakCount: Int {
        return data.maxStreakCount
    }
    
    func hasScore () -> Bool {
        return data.hasScore()
    }
    
    func start () {
        return data.start()
    }
    
    var numSelectedLinesX: Int {
        return data.numSelectedLinesX
    }
    
    var numSelectedLinesY: Int {
        return data.numSelectedLinesY
    }
    
    var numSelectedLines: Int {
        return data.numSelectedLines
    }
    
    var minNumSelectedLinesXY: Int {
        return data.minNumSelectedLinesXY
    }
    
    func incSelectedCells () {
        data.numSelectedCells += 1
    }
    
    func resetStreakCount () {
        currentStreakCount = 0
    }
    
    func incStreakCount () {
        currentStreakCount += 1
        if currentStreakCount > data.maxStreakCount {
            data.maxStreakCount = currentStreakCount
        }
    }
    
    func addNumSelectedLines (type: CloseItObject.Object, num: Int) {
        if type == .isLineX {
            data.numSelectedLinesX += num
        }
        else if type == .isLineY {
            data.numSelectedLinesY += num
        }
    }
    
/*    func setNumSelectedLines (board: CloseItBoard) {
            data.numSelectedLinesX = board.getNumSelectedLinesXNotAtSelectedCells()
        }
        currentNumSelectedLinesY = board.getNumSelectedLinesYNotAtSelectedCells()
        if currentNumSelectedLinesY > data.numSelectedLinesY {
            self.data.numSelectedLinesY = self.currentNumSelectedLinesY
        }
    }
 */
    func incNumRestarts () {
        data.numRestarts += 1
    }
    
    func incNumUndos () {
        data.numUndos += 1
    }
    
    func incNumRedos () {
        data.numRedos += 1
    }

    func hasData (boardId: String, userId: String?, includeChallenges: Bool) -> Bool {
        if (self.boardId == boardId && (includeChallenges || !self.isChallenge) && (userId != nil ? self.userId == userId! : true)) {
            return true
        }
        return false
    }
    
    func setWon (won: Bool) {
        data.done(won: won)
    }
    
    func reset () {
        data.reset()
        currentStreakCount = 0
    }
    
    func getAchievement (otherBoardId: String, otherUserId: String, otherIsChallenge: Bool, otherChallenge: String, otherIsBoard: Bool, level: Level) -> CloseItAchievementGames {
        CLOSEIT_TYPE_FUNC_START(self)
        var r = CloseItAchievementGames(level: level, userId: otherUserId)
        
        if boardId == otherBoardId && data.userId == otherUserId && data.level <= level && (isChallenge && otherIsChallenge && challenge == otherChallenge || isBoard && otherIsBoard) {
            r += data
        }
        CLOSEIT_TYPE_FUNC_END(self, " -> \(r.value(showName: true))")
        return r
    }
    
    func getAchievement (game: CloseItGame, userId: String, level: Level) -> CloseItAchievementGames {
        CLOSEIT_TYPE_FUNC_START(self)
        let r = getAchievement(otherBoardId: game.board.boardId, otherUserId: userId, otherIsChallenge: game.board.isChallenge, otherChallenge: game.board.challenge, otherIsBoard: game.board.isBoard, level: level)
        
        CLOSEIT_TYPE_FUNC_END(self, " -> \(r.value(showName: true))")
        return r
    }

    static func getAchievement (scores: [CloseItScore], game: CloseItGame, userId: String, level: Level) -> CloseItAchievementGames {
        CLOSEIT_FUNC_START()
        var r = CloseItAchievementGames(level: level, userId: userId)
        
        for s in scores {
            let c = s.getAchievement(game: game, userId: userId, level: level)
            r += c
        }
        CLOSEIT_FUNC_END(" -> \(r.value(showName: true))")
        return r
    }

    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        return data.value(showName: showName, sep: sep)
    }
}
