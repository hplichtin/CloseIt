//
//  CloseItGamesGroup.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 20.12.21.
//

import Foundation

class CloseItGames: CloseItLog {
    class Data: Identifiable, ObservableObject {
        var id = UUID()
        var game: CloseItGame
        var achievedObjects = CloseItAchievementGroup(level: 0, userId: "")
        var achievedScores = CloseItAchievementGames(level: 0, userId: "")
        
        init () {
            game = CloseItGame.defaultGame()
        }
        
        init (game: CloseItGame) {
            self.game = game
        }
    }
    var url: URL?
    var data: [Data] = []
    
    var achievedObjects = CloseItAchievementGroup(level: 0, userId: "")
    var achievedScores = CloseItAchievementGames(level: 0, userId: "")
    
    init (url: URL? = nil) {
        self.url = url
    }
    
    var count: Int {
        return data.count
    }
    
    var isEmpty: Bool {
        return data.isEmpty
    }
    
    func hasGames (level: Level, numDaysPlayed: Int) -> Bool {
        CLOSEIT_TYPE_FUNC_START(self, " level: \(level)")
        for d in data {
            if d.game.board.level <= level && d.game.board.availableAfterDays <= numDaysPlayed {
                CLOSEIT_TYPE_FUNC_END(self, " -> true")
                return true
            }
        }
        CLOSEIT_TYPE_FUNC_END(self, " -> false")
        return false
    }
    
    func getBoardName (boardId: String) -> String {
        for d in data {
            if d.game.board.boardId == boardId {
                return d.game.board.boardName
            }
        }
        return ""
    }
    
    func getGame (gameId: UUID) -> CloseItGame {
        for d in data {
            if d.game.id == gameId {
                return d.game
            }
        }
        myMessage.error("CloseItGamesArray.getGame: gameId \(gameId) not found")
    }
    
    func setUser (user: CloseItUser) {
        for d in data {
            d.game.setUser(user: user)
        }
    }
    
    func append (game: CloseItGame) {
        var i = data.count - 1
        
        while i >= 0 {
            let dg = data[i].game
            
            if dg.board.level <= game.board.level {
                data.insert(Data(game: game), at: i + 1)
                return
            }
            i -= 1
        }
        data.insert(Data(game: game), at: 0)
    }
    
    func append (dataBoard: CloseItDataBoard, challenge: String, level: Level, availableAfterDays: Int) {
        let game = CloseItGame(dataBoard: dataBoard, challenge: challenge, level: level, availableAfterDays: availableAfterDays)
        
        append(game: game)
    }
    
    /*
     func append (dataBoards: [CloseItDataBoard]) {
     for d in dataBoards {
     append(dataBoard: d)
     }
     }*/
    
    func load (group: String, doActions: Bool, mode: CloseItGame.Mode) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(url != nil)
        
        var dataGames: [CloseItDataGame] = []
        
        CloseItDataGame.load(url: url!, data: &dataGames)
        for d in dataGames {
            let dataBoard = CloseItDataBoard(group: group, dataGame: d)
            let game = CloseItGame(dataGame: d, dataBoard: dataBoard, doActions: doActions, mode: mode)
            
            append(game: game)
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func store () {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(url != nil)

        var dataGames: [CloseItDataGame] = []
        
        for d in data {
            let data = d.game.data()
            
            dataGames.append(data)
        }
        CloseItDataGame.store(url: url!, data: dataGames)
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func calculateAchievements (userId: String, boardScores: CloseItBoardScores, level: Level, numDaysPlayed: Int) {
        CLOSEIT_TYPE_FUNC_START(self)
        var d = 0
        
        achievedObjects.reset(level: level, userId: userId)
        achievedScores.reset(level: level, userId: userId)
        while d < data.count {
            data[d].achievedObjects.reset(level: level, userId: userId)
            
            if data[d].game.board.level <= level && data[d].game.board.availableAfterDays <= numDaysPlayed {
                achievedObjects.num += 1
                data[d].achievedObjects.num = 1
                data[d].achievedScores = boardScores.getAchievement(game: data[d].game, userId: userId, level: level)
                achievedScores += data[d].achievedScores
                if data[d].achievedScores.numCompleted > 0 {
                    achievedObjects.numCompleted += 1
                    data[d].achievedObjects.numCompleted = 1
                }
            }
            d += 1
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
}

class CloseItGamesGroup: CloseItLog, ObservableObject {
    class Data: Identifiable, ObservableObject {
        var group: String
        var games = CloseItGames()
        
        init (group: String) {
            self.group = group
        }
        
        var id: String { return group }
        
        var groupName: String {
            return CloseItBoard.getGroupName(group: group)
        }
                
        func hasGames (level: Level, numDaysPlayed: Int) -> Bool {
            return games.hasGames(level: level, numDaysPlayed: numDaysPlayed)
        }
    }
    
    var data: [Data]
    
    var achievedGroups = CloseItAchievementGroup(level: 0, userId: "")
    @Published var achievedObjects = CloseItAchievementGroup(level: 0, userId: "")
    var achievedScores = CloseItAchievementGames(level: 0, userId: "")
    
    init () {
        data = []
    }
        
    var isEmpty: Bool {
        return data.isEmpty
    }

    func getBoardName (boardId: String) -> String {
        for d in data {
            for g in d.games.data {
                if g.game.board.boardId == boardId {
                    return g.game.board.boardName
                }
            }
        }
        return ""
    }
    
    func getBoard (boardId: String) -> CloseItBoard? {
        for d in data {
            for g in d.games.data {
                if g.game.board.boardId == boardId {
                    return g.game.board
                }
            }
        }
        return nil
    }
    
    func setUser (user: CloseItUser) {
        for d in data {
            for g in d.games.data {
                if g.game.hasScore {
                    g.game.restart()
                }
                g.game.setUser(user: user)
            }
        }
    }

    func add (group: String, game: CloseItGame) {
        var i = 0

        while i < data.count {
            if data[i].group == group {
                break
            }
            i += 1
        }
        if i == data.count {
            data.append(Data(group: group))
        }
        data[i].games.append(game: game)
    }
    
    func add (dataBoards: [CloseItDataBoard]) {
        CLOSEIT_TYPE_FUNC_START(self)
        for d in dataBoards {
            let game = CloseItGame(dataBoard: d, challenge: "", level: 0, availableAfterDays: 0)
            
            add(group: d.group, game: game)
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func add (dataChallenges: [CloseItDataChallenge], dataBoards: [CloseItDataBoard]) {
        CLOSEIT_TYPE_FUNC_START(self)

        for dc in dataChallenges {
            var boardFound = false
            
            for db in dataBoards {
                if dc.boardId == db.id {
                    let game = CloseItGame(dataBoard: db, challenge: dc.challenge, level: dc.level, availableAfterDays: dc.availableAfterDays)
                    
                    add(group: dc.group, game: game)
                    boardFound = true
                    break
                }
            }
            if !boardFound {
                myMessage.warning("\(dc): unexpected boardId:'\(dc.boardId)'")
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
/*    func load (group: String) {
        var dataGames: [CloseItDataGame] = []
        
        CloseItDataGame.load(data: &dataGames)
        for d in dataGames {
            let dataBoard = CloseItDataBoard(group: group, dataGame: d)
            let game = CloseItGame(dataGame: d, dataBoard: dataBoard)
            
            add(group: group, game: game)
        }
    }
    
    func store () {
        var dataGames: [CloseItDataGame] = []

        for d in data {
            for g in d.games.data {
                dataGames.append(g.game.data())
            }
        }
        CloseItDataGame.store(data: dataGames)
    }
 */
    var numBoardGroups: Int {
        let n = data.count

        return n
    }

    var numBoards: Int {
        var n = 0

        for d in data {
            n += d.games.count
        }
        return n
    }

/*    func numBoardsCompleted (userId: String, group: String, scores: CloseItBoardScores, level: Level, numBoards: inout Int) -> Int {
        numBoards = 0
        for d in data {
            if d.group == group {
                var n = 0
                
                numBoards = d.games.count
                for g in d.games.games {
                    let boardNum = scores.getNumScores(game: g, userId: userId, level: level)
                    
                    if boardNum.numCompleted > 0 {
                        n += 1
                    }
                }
                return n
            }
        }
        return 0
    }
*/
    var completed: Bool {
        return achievedGroups.completed && achievedObjects.completed
    }
    
    func updateAchievements (score: CloseItScore) {
        CLOSEIT_TYPE_FUNC_START(self)
        for d in data {
            for g in d.games.data {
                let a = score.getAchievement(game: g.game, userId: score.userId, level: achievedGroups.level)
                
                if a.numPlayed > 0 {
                    g.achievedScores += a
                    d.games.achievedScores += a
                    achievedScores += a
                }
                if a.numCompleted > 0 && g.achievedObjects.numCompleted == 0 {
                    g.achievedObjects.numCompleted += 1
                    d.games.achievedObjects.numCompleted += 1
                    achievedObjects.numCompleted += 1
                    if d.games.achievedObjects.completed {
                        achievedGroups.numCompleted += 1
                    }
                }
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }

    func calculateAchievements (userId: String, boardScores: CloseItBoardScores, level: Level, numDaysPlayed: Int) {
        CLOSEIT_TYPE_FUNC_START(self)
        var d = 0
        
        achievedGroups.reset(level: level, userId: userId)
        achievedObjects.reset(level: level, userId: userId)
        achievedScores.reset(level: level, userId: userId)
        while d < data.count {
            if data[d].hasGames(level: level, numDaysPlayed: numDaysPlayed) {
                
                achievedGroups.num += 1
                data[d].games.calculateAchievements(userId: userId, boardScores: boardScores, level: level, numDaysPlayed: numDaysPlayed)
                achievedObjects += data[d].games.achievedObjects
                achievedScores += data[d].games.achievedScores
                if data[d].games.achievedObjects.completed {
                    achievedGroups.numCompleted += 1
                }
            }
            d += 1
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func restartGames () {
        for d in data {
            for g in d.games.data {
                g.game.restart()
            }
        }
    }
}
