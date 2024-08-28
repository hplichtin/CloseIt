//
//  CloseItGame_Test.swift
//  CloseItTests
//
//  Created by Hans-Peter Lichtin on 25.09.22.
//

import XCTest
@testable import CloseIt

class CloseItAction_GameTest: CloseItAction {
    var countSleep = 0
    var countDoit = 0
    var countUndoit = 0
    var countRedoit = 0
    
    override func copy() -> CloseItAction {
        let action = CloseItAction_GameTest(action: self)
        
        action.countDoit = countDoit
        action.countUndoit = countUndoit
        return action
    }
    
    override func sleep () {
        countSleep += 1
    }
    
    override func doit () {
        countDoit += 1
    }
    
    override func undoit () {
        countUndoit += 1
    }
    
    override func redoit () {
        countRedoit += 1
    }
}

class CloseItGame_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnit() throws {
        var i: Int
        var dataBoard: CloseItDataBoard
        var game, game2: CloseItGame
        var action: CloseItAction_GameTest

        let sizeX: [Int] = [ 1, 1, 2, 2, 4, 4, 8, 8, 1, 2, 4, 8 ]
        let sizeY: [Int] = [ 1, 1, 2, 2, 4, 4, 8, 8, 8, 4, 2, 1 ]
        let cells: [String] = [ "I", "S", "IIII", "OOSS", "OOOOOIIOOIIOOOOO", "IIII IIII IIII IIII"  ]
        let cellsStatus: [String] = [ "I", "S", "IIII", "OOSS", "OOOOOIIOOIIOOOOO", "IIIIIIIIIIIIIIII" ]
        let lineXStatus: [String] = [ "BB", "BB", "BIBBIB", "OOOBSB", "OOOOOOBIBOOBIBOOOOOO", "BIIIBBIIIBBIIIBBIIIB" ]
        let lineYStatus: [String] = [ "BB", "BB", "BBIIBB", "OOBBBB", "OOOOOBBOOIIOOBBOOOOO", "BBBBIIIIIIIIIIIIBBBB" ]
        let cellsIsSelectable: [String] = [ "s", "-", "----", "----", "----------------", "----------------" ]
        let lineXIsSelectable: [String] = [ "--", "--", "-s--s-", "------", "-------s----s-------", "-sss--sss--sss--sss-" ]
        let lineYIsSelectable: [String] = [ "--", "--", "--ss--", "------", "---------ss---------", "----ssssssssssss----" ]
        let challenge: [String] = [ "", "", "challenge", "challenge", "challenge", "" ]
        let mode: [CloseItGame.Mode] = [ .isSingleUser, .isMultiUser, .isSingleUser, .isMultiUser, .isSingleUser, .isMultiUser ]
        var userId: [String] = []
        var userId2: [String] = []
        var user: [CloseItUser] = []
        var user2: [CloseItUser] = []

        i = 0
        while i < cells.count {
            var j: Int
            
            myMessage.log("CloseItGame_Test.testUnit: i = \(i)")

            dataBoard = CloseItDataBoard(program: "program", type: "type", version: "version", group: "group", id: "id", designer: "designed", sizeX: sizeX[i], sizeY: sizeY[i], cells: cells[i])
            userId.append("\(UUID()))")
            user.append(CloseItUser(id: userId[i]))
            userId2.append("\(UUID())")
            user2.append(CloseItUser(id: userId2[i]))
            // init dataBoard, challenge, level
            game = CloseItGame(dataBoard: dataBoard, challenge: challenge[i], level: i, availableAfterDays: 0)
            XCTAssert(!game.isFinished)
            XCTAssert(!game.isDisabled)
            XCTAssert(game.mode == .isSingleUser)
            XCTAssert(game.playMe)
            XCTAssert(!game.playOther)
            XCTAssert(game.board.boardGroup == "group")
            XCTAssert(game.board.boardId == "id")
            XCTAssert(game.board.boardName == "[KEY|boardName|id]")
            XCTAssert(game.board.sizeX == sizeX[i])
            XCTAssert(game.board.sizeY == sizeY[i])
            XCTAssert(game.board.cells.getStatus() == cellsStatus[i])
            // myMessage.log(game.board.linesX.getStatus())
            XCTAssert(game.board.linesX.getStatus() == lineXStatus[i])
            XCTAssert(game.board.linesY.getStatus() == lineYStatus[i])
            XCTAssert(game.board.cells.getIsSelectable() == cellsIsSelectable[i])
            // myMessage.log(game.board.linesX.getIsSelectable())
            XCTAssert(game.board.linesX.getIsSelectable() == lineXIsSelectable[i])
            XCTAssert(game.board.linesY.getIsSelectable() == lineYIsSelectable[i])
            XCTAssert(game.board.size == sizeX[i] * sizeY[i])
            XCTAssert(game.board.challenge == challenge[i])
            XCTAssert(game.board.level == i)
            XCTAssert(game.userId == "")
            XCTAssert(game.myScore == nil)
            XCTAssert(game.otherScore == nil)
            XCTAssert(game.steps.isEmpty)
            XCTAssert(game.stepsIndex == 0)
            XCTAssert(game.isAutoClose)
            XCTAssert(!game.canUndo)
            XCTAssert(!game.canRedo)
            
            // init game
            game = CloseItGame(dataBoard: dataBoard, challenge: challenge[i], level: i + 1, availableAfterDays: 0)
            game.myScore = CloseItScore(game: game)
            game.otherScore = CloseItScore(game: game)
            game2 = CloseItGame(game: game)
            XCTAssert(game2.isFinished == game.isFinished)
            XCTAssert(game2.mode == game.mode)
            XCTAssert(game2.board.boardGroup == game.board.boardGroup)
            XCTAssert(game2.board.boardId == game.board.boardId)
            XCTAssert(game2.board.boardName == game.board.boardName)
            XCTAssert(game2.board.sizeX == game.board.sizeX)
            XCTAssert(game2.board.sizeY == game.board.sizeY)
            XCTAssert(game2.board.cells.getStatus() == game.board.cells.getStatus())
            XCTAssert(game2.board.linesX.getStatus() == game.board.linesX.getStatus())
            XCTAssert(game2.board.linesY.getStatus() == game.board.linesY.getStatus())
            XCTAssert(game2.board.cells.getIsSelectable() == game.board.cells.getIsSelectable())
            XCTAssert(game2.board.linesX.getIsSelectable() == game.board.linesX.getIsSelectable())
            XCTAssert(game2.board.linesY.getIsSelectable() == game.board.linesY.getIsSelectable())
            XCTAssert(game2.board.size == game.board.size)
            XCTAssert(game2.board.challenge == game.board.challenge)
            XCTAssert(game2.board.level == i + 1)
            XCTAssert(game2.myScore!.gameId == game2.id)
            XCTAssert(game2.myScore!.userId == "")
            XCTAssert(game2.otherScore!.gameId == game2.id)
            XCTAssert(game2.otherScore!.userId == "")
            XCTAssert(game2.canUndo == game.canUndo)
            XCTAssert(game2.canRedo == game.canRedo)
            XCTAssert(game2.id != game.id)
            
            // setUser
            game = CloseItGame(dataBoard: dataBoard, challenge: challenge[i], level: i + 1, availableAfterDays: 0)
            game2 = CloseItGame(game: game)
            game2.myScore = CloseItScore(game: game2)
            game2.otherScore = CloseItScore(game: game2)
            game.setUser(user: user[i])
            XCTAssert(game.myScore != nil)
            XCTAssert(game.myScore!.gameId == game.id)
            XCTAssert(game.myScore!.userId == user[i].id)
            XCTAssert(game.otherScore == nil)
            XCTAssert(game2.myScore != nil)
            XCTAssert(game2.myScore!.gameId == game2.id)
            XCTAssert(game2.myScore!.userId == "")
            XCTAssert(game2.otherScore != nil)
            XCTAssert(game2.otherScore!.gameId == game2.id)
            XCTAssert(game2.otherScore!.userId == "")
        
            // static defaultGame
            game = CloseItGame.defaultGame()
            XCTAssert(game.board.sizeX == CloseItGame.defaultGameSizeX)
            XCTAssert(game.board.sizeY == CloseItGame.defaultGameSizeY)
            XCTAssert(game.board.cells.getStatus() == CloseItGame.defaultGameCells)
            
            // copyScores, pastScores
            var copyMyScore: CloseItScore? = nil
            var copyOtherScore: CloseItScore? = nil
            
            game = CloseItGame(dataBoard: dataBoard, challenge: challenge[i], level: i, availableAfterDays: 0)
            game.copyScores(copyMyScore: &copyMyScore, copyOtherScore: &copyOtherScore)
            XCTAssert(copyMyScore == nil)
            XCTAssert(copyOtherScore == nil)
            
            game.myScore = CloseItScore(game: game)
            game.copyScores(copyMyScore: &copyMyScore, copyOtherScore: &copyOtherScore)
            XCTAssert(copyMyScore != nil)
            XCTAssert(copyMyScore!.gameId == game.id)
            XCTAssert(copyMyScore!.userId == "")
            XCTAssert(copyOtherScore == nil)
            
            game.otherScore = CloseItScore(game: game)
            game.copyScores(copyMyScore: &copyMyScore, copyOtherScore: &copyOtherScore)
            XCTAssert(copyMyScore != nil)
            XCTAssert(copyMyScore!.gameId == game.id)
            XCTAssert(copyMyScore!.userId == "")
            XCTAssert(copyOtherScore != nil)
            XCTAssert(copyOtherScore!.gameId == game.id)
            XCTAssert(copyOtherScore!.userId == "")
            
            game.setUser(user: user[i])
            game.copyScores(copyMyScore: &copyMyScore, copyOtherScore: &copyOtherScore)
            XCTAssert(copyMyScore != nil)
            XCTAssert(copyMyScore!.gameId == game.id)
            XCTAssert(copyMyScore!.userId == user[i].id)
            XCTAssert(copyOtherScore != nil)
            XCTAssert(copyOtherScore!.gameId == game.id)
            XCTAssert(copyOtherScore!.userId == "")
            
            game.setUser(user: CloseItUser(id: userId2[i]))
            XCTAssert(game.myScore!.userId == userId2[i])
            XCTAssert(copyMyScore!.userId == user[i].id)
            XCTAssert(copyOtherScore != nil)
            XCTAssert(copyOtherScore!.gameId == game.id)
            XCTAssert(copyOtherScore!.userId == "")

            game.setUser(user: CloseItUser(id: UUID().description))
            XCTAssert(copyMyScore!.userId == user[i].id)
            
            game2 = CloseItGame(dataBoard: dataBoard, challenge: challenge[i], level: i, availableAfterDays: 0)
            copyMyScore = CloseItScore(game: game2)
            copyMyScore!.userId = userId[i]
            copyOtherScore = CloseItScore(game: game2)
            copyOtherScore!.userId = userId2[i]
            game2.pasteScore(pasteMyScore: copyMyScore!, pasteOtherScore: copyOtherScore!)
            XCTAssert(game2.myScore != nil)
            XCTAssert(game2.myScore!.gameId == game2.id)
            XCTAssert(game2.myScore!.userId == userId[i])
            XCTAssert(game2.otherScore != nil)
            XCTAssert(game2.otherScore!.gameId == game2.id)
            XCTAssert(game2.otherScore!.userId == userId2[i])
            copyMyScore!.userId = userId2[i]
            copyOtherScore!.userId = userId[i]
            XCTAssert(game2.myScore != nil)
            XCTAssert(game2.myScore!.gameId == game2.id)
            XCTAssert(game2.myScore!.userId == userId[i])
            XCTAssert(game2.otherScore != nil)
            XCTAssert(game2.otherScore!.gameId == game2.id)
            XCTAssert(game2.otherScore!.userId == userId2[i])
            
            game2 = CloseItGame(dataBoard: dataBoard, challenge: challenge[i], level: i, availableAfterDays: 0)
            copyMyScore = CloseItScore(game: game)
            copyMyScore!.userId = userId[i]
            copyOtherScore = CloseItScore(game: game)
            copyOtherScore!.userId = userId2[i]
            game2.pasteScore(pasteMyScore: copyMyScore!, pasteOtherScore: copyOtherScore!)
            XCTAssert(game2.myScore != nil)
            XCTAssert(game2.myScore!.gameId == game2.id)
            XCTAssert(game2.myScore!.userId == userId[i])
            XCTAssert(game2.otherScore != nil)
            XCTAssert(game2.otherScore!.gameId == game2.id)
            XCTAssert(game2.otherScore!.userId == userId2[i])

            // mode
            game = CloseItGame(dataBoard: dataBoard, challenge: challenge[i], level: i, availableAfterDays: 0)
            XCTAssert(game.mode == .isSingleUser)
            // won & restart
            game = CloseItGame(dataBoard: dataBoard, challenge: "", level: i, availableAfterDays: 0)
            XCTAssert(!game.isFinished)
            game.won()
            XCTAssert(game.isFinished)
            XCTAssert(game.myScore == nil)
            game.restart()
            game.setUser(user: user[i])
            XCTAssert(!game.isFinished)
            XCTAssert(!game.myScore!.won)
            game.won()
            XCTAssert(game.myScore != nil)
            XCTAssert(game.isFinished)
            XCTAssert(game.myScore!.won)
            // doit, undoit, redoit: .isUserAction
            game = CloseItGame(dataBoard: dataBoard, challenge: challenge[i], level: i, availableAfterDays: 0)
            action = CloseItAction_GameTest(game: game, undo: true, source: .isUserAction)
            game.doit(action: action)
            XCTAssert(action.countDoit == 1)
            XCTAssert(game.canUndo)
            XCTAssert(!game.canRedo)
            game.undoit()
            XCTAssert(action.countUndoit == 1)
            XCTAssert(!game.canUndo)
            XCTAssert(game.canRedo)
            game.redoit()
            XCTAssert(action.countRedoit == 1)
            XCTAssert(game.canUndo)
            XCTAssert(!game.canRedo)
            game.undoit()
            XCTAssert(action.countUndoit == 2)
            XCTAssert(!game.canUndo)
            XCTAssert(game.canRedo)
            // doit, undoit, redoit: .isAutoAction
            action = CloseItAction_GameTest(game: game, undo: true, source: .isAutoAction)
            j = 0
            while j <= i {
                game.doit(action: action)
                XCTAssert(action.countDoit == j + 1)
                XCTAssert(game.canUndo)
                XCTAssert(!game.canRedo)
                j += 1
            }
            game.undoit()
            XCTAssert(action.countUndoit == i + 1)
            XCTAssert(!game.canUndo)
            XCTAssert(game.canRedo)
            game.redoit()
            XCTAssert(action.countRedoit == i + 1)
            XCTAssert(game.canUndo)
            XCTAssert(!game.canRedo)
            game.undoit()
            XCTAssert(action.countUndoit == 2 * (i + 1))
            XCTAssert(!game.canUndo)
            XCTAssert(game.canRedo)
            // doit, undoit: undo: false
            action = CloseItAction_GameTest(game: game, undo: false, source: .isUserAction)
            game.doit(action: action)
            XCTAssert(action.countDoit == 1)
            XCTAssert(!game.canUndo)
            XCTAssert(!game.canRedo)
            game.undoit()
            XCTAssert(action.countUndoit == 0)
            XCTAssert(!game.canUndo)
            XCTAssert(!game.canRedo)
            game.redoit()
            XCTAssert(action.countDoit == 1)
            XCTAssert(!game.canUndo)
            XCTAssert(!game.canRedo)
            
            i += 1
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
