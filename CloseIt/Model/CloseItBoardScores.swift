//
//  CloseItBoardScores.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 15.12.21.
//

import Foundation

class CloseItBoardScores: CloseItClass {
    
    struct Data: Identifiable {
        var id: String
        var isScoresCollapsed: Bool = false
        var scores: [CloseItScore]
        
        init (scores: [CloseItScore]) {
            precondition(!scores.isEmpty)
            self.scores = scores
            id = scores[0].boardId + "." + scores[0].scoreId
        }
        
        var boardId: String  {
            return scores.isEmpty ? "" : scores[0].boardId
        }
        
        var boardName: String {
            return scores.isEmpty ? "" : scores[0].boardName
        }
        
        var scoreId: String {
            return scores.isEmpty ? "" : scores[0].scoreId
        }
        
        var groupRank: Int {
            return scores.isEmpty ? 0 : scores[0].groupRank
        }
        
        static func == (lhs: Data, rhs: Data) -> Bool {
            return lhs.boardId == rhs.boardId && lhs.scoreId == rhs.scoreId
        }
        
        static func < (lhs: Data, rhs: Data) -> Bool {
            if lhs.boardId < rhs.boardId {
                return true
            }
            if lhs.boardId > rhs.boardId {
                return false
            }
            return lhs.scores[0] < rhs.scores[0]
        }
    }
    
    var data: [Data]
    
    override init () {
        data = []
    }
    
    func reset () {
        data = []
    }
    
    var count: Int {
        var c = 0
        
        for b in data {
            c += b.scores.count
        }
        return c
    }
    
    func rankScores () {
        CLOSEIT_TYPE_FUNC_START(self)
        var groupRank = 1
        var scoreRank = 1
        var boardId = ""
        var b = 0
        
        while b < data.count {
            var s = 0
            
            if data[b].boardId != boardId {
                groupRank = 1
                scoreRank = 1
                boardId = data[b].boardId
            }
            while s < data[b].scores.count {
                data[b].scores[s].groupRank = groupRank
                data[b].scores[s].scoreRank = scoreRank
                scoreRank += 1
                s += 1
            }
            groupRank += 1
            b += 1
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func add (score: CloseItScore) {
        CLOSEIT_TYPE_FUNC_START(self)
        var b = 0
        
        score.groupRank = 0
        score.scoreRank = 0
        while b < data.count {
            if score.boardId == data[b].boardId && score.scoreId == data[b].scoreId {
                var s = 0
                
                while s < data[b].scores.count {
                    if score < data[b].scores[s] {
                        break
                    }
                    s += 1
                }
                data[b].scores.insert(score, at: s)
                CLOSEIT_TYPE_FUNC_END(self)
                return
            }
            if score.boardId < data[b].boardId || (score.boardId == data[b].boardId && score < data[b].scores[0]) {
                break
            }
            b += 1
        }
        data.insert(Data(scores: [score]), at: b)
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func add (score: CloseItScore, onlyHasScore: Bool = false) {
        if !onlyHasScore || score.hasScore() {
            add(score: score)
        }
    }
    
    func add (scores: [CloseItScore], onlyHasScore: Bool = false) {
        for s in scores {
            add(score: s, onlyHasScore: onlyHasScore)
        }
    }
    
    func addCopy (score: CloseItScore) {
        add(score: CloseItScore(score: score))
    }
    
    func getScores (boardId: String, scoreId: String) -> [CloseItScore] {
        for b in data {
            if b.boardId == boardId && b.scoreId == scoreId {
                return b.scores
            }
        }
        return []
    }
    
    func setGames (gamesArray: CloseItGames) {
        for b in data {
            for s in b.scores {
                s.game = nil
                s.isGameStored = false
                for g in gamesArray.data {
                    if s.gameId == g.game.id {
                        s.game = g.game
                        g.game.myScore = s
                        g.game.isFinished = true
                        s.isGameStored = true
                        break
                    }
                }
            }
        }
    }
    
    func achieved (userId: String, level: Level, achievementBoards: inout CloseItAchievementGames, achievementChallenges: inout CloseItAchievementGames) {
        achievementBoards = CloseItAchievementGames(level: level, userId: userId)
        achievementChallenges = CloseItAchievementGames(level: level, userId: userId)
        for b in data {
            for s in b.scores {
                if s.userId == userId && s.data.level <= level {
                    if s.isBoard {
                        achievementBoards += s.data
                    }
                    else if s.isChallenge {
                        achievementChallenges += s.data
                    }
                }
            }
        }
    }

    /// get number of scores
    func getAchievement (game: CloseItGame, userId: String, level: Level) -> CloseItAchievementGames {
        CLOSEIT_TYPE_FUNC_START(self)
        var r = CloseItAchievementGames(level: level, userId: userId)
        
        for b in data {
            if b.boardId == game.board.boardId {
                for s in b.scores {
                    let c = s.getAchievement(game: game, userId: userId, level: level)
                    r += c
                }
            }
        }
        CLOSEIT_TYPE_FUNC_END(self, " -> \(r.value(showName: true))")
        return r
    }
    
    func getAchievement (game: CloseItGame, level: Level) -> CloseItAchievementGames {
        CLOSEIT_TYPE_FUNC_START(self)
        var r = CloseItAchievementGames(level: level, userId: game.userId)
        
        for b in data {
            if b.boardId == game.board.boardId {
                for s in b.scores {
                    let c = s.getAchievement(game: game, userId: game.userId, level: level)
                    r += c
                }
            }
        }
        CLOSEIT_TYPE_FUNC_END(self, " -> \(r.value(showName: true))")
        return r
    }
    
    func getAchievement (score: CloseItScore, level: Level) -> CloseItAchievementGames {
        CLOSEIT_TYPE_FUNC_START(self)
        var r = CloseItAchievementGames(level: level, userId: score.userId)
        
        for b in data {
            if b.boardId == score.boardId {
                for s in b.scores {
                    let c = s.getAchievement(otherBoardId: score.boardId, otherUserId: score.userId, otherIsChallenge: score.isChallenge, otherChallenge: score.challenge, otherIsBoard: score.isBoard, level: level)
                    r += c
                }
            }
        }
        CLOSEIT_TYPE_FUNC_END(self, " -> \(r.value(showName: true))")
        return r
    }
    
    func getGroupRank (score: CloseItScore) -> Int {
        for b in data {
            if b.boardId == score.boardId && b.scoreId == score.scoreId {
                return b.groupRank
            }
        }
        return 0
    }
 
    func getScoreRank (score: CloseItScore) -> Int {
        for b in data {
            if b.boardId == score.boardId && b.scoreId == score.scoreId {
                for s in b.scores {
                    if s == score {
                        return s.scoreRank
                    }
                }
                return 0
            }
        }
        return 0
    }

    /*
    func getScore (scoreId: UUID) -> CloseItScore {
        for b in boardsScores {
            for s in b.scores {
                if s.id == scoreId {
                    return s
                }
            }
        }
        myMessage.error("unexpected scoreID:'\(scoreId)")
    }*/
    
    func store () {
        var scores: [CloseItScore] = []
        
        for b in data {
            CloseItScore.append(from: b.scores, to: &scores, onlyHasScore: true)
        }
        CloseItScore.store(objects: scores)
    }
}

