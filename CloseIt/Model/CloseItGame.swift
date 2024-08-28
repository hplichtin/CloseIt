//
//  CloseItGame.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import Foundation
import SwiftUI

class CloseItGame: CloseItClass, ObservableObject, Identifiable, Comparable {
    @Published var isFinished: Bool = false
    @Published var isDisabled: Bool = false
    @Published var isProcessing: Bool = false

    enum Mode {
        case isSingleUser, isMultiUser, isReview, inDemo
    }
    
    @Published var mode: Mode = .isSingleUser

    var playMe: Bool = true
    
    var playOther: Bool {
        return !playMe
    }

    var board: CloseItBoard
    @Published var userId: String = ""
    @Published var myScore: CloseItScore? = nil
    @Published var otherScore: CloseItScore? = nil
    private var actions: CloseItGameActions = CloseItGameActions()
    var steps: [Int]
    @Published var stepsIndex: Int

    @Published var isAutoClose: Bool = true
    @Published var canUndo: Bool = false
    @Published var canRedo: Bool = false
    
    var sleepSeconds: Double = 0.0

    var id: UUID
    
    var lastLine: CloseItObject? = nil
    
    static func == (lhs: CloseItGame, rhs: CloseItGame) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: CloseItGame, rhs: CloseItGame) -> Bool {
        lhs.id < rhs.id
    }

    init (dataBoard: CloseItDataBoard, challenge: String, level: Level, availableAfterDays: Int) {
        board = CloseItBoard(data: dataBoard, challenge: challenge, level: level, availableAfterDays: availableAfterDays)
        steps = []
        stepsIndex = 0
        id = UUID()
    }
    
    init (game: CloseItGame, newId: Bool = true, reviewGame: Bool = false) {
        isFinished = game.isFinished
        mode = game.mode
        board = CloseItBoard(board: game.board)
        userId = game.userId
        myScore = game.myScore != nil ? CloseItScore(score: game.myScore!) : nil
        otherScore = game.otherScore != nil ? CloseItScore(score: game.otherScore!) : nil
        steps = game.steps
        stepsIndex = game.stepsIndex
        if newId {
            id = UUID()
        }
        else {
            id = game.id
        }
        super.init()
        if reviewGame {
            let encodedSring = game.actions.logData()
            
            mode = .isReview
            setReviewActions(encodedStr: encodedSring, doActions: true)
        }
        isAutoClose = game.isAutoClose
        resetScores()
    }
    
    init (dataGame: CloseItDataGame, dataBoard: CloseItDataBoard, doActions: Bool, mode: Mode) {
        self.mode = mode
        board = CloseItBoard(data: dataBoard, challenge: dataGame.challenge, level: dataGame.level, availableAfterDays: 0)
        id = dataGame.id
        userId = dataGame.userId
        steps = dataGame.steps
        stepsIndex = 0
        
        super.init()
        if dataGame.actions != "[]" {
            let encodedString = dataGame.actions

            setReviewActions(encodedStr: encodedString, doActions: doActions)
        }
    }

    private func resetScores () {
        if myScore != nil {
            myScore!.reset()
            myScore!.userId = userId
            myScore!.gameId = id
            myScore!.game = self
        }
        if otherScore != nil {
            otherScore!.reset()
            otherScore!.userId = userId
            otherScore!.gameId = id
            otherScore!.game = self
        }
    }

    override func helpType () -> String {
        return board.helpType()
    }
    
    override func helpId () -> String {
        var helpId = board.helpId()
        
        if mode == .inDemo && steps.count > 0 {
            helpId += separator + "\(stepsIndex)"
        }
        return helpId
    }

    var step: Int {
        return stepsIndex
    }
    
    private func setReviewActions (encodedStr: String, doActions: Bool) {
        let reviewActions = CloseItActionReview.decode(game: self, encodedStr: encodedStr)
        
        actions.reset()
        for a in reviewActions {
            if doActions {
                doit(action: a)
            }
            else {
                actions.addActionToLog(action: a, function: a.function)
            }
        }
    }
    
    /*var status: Status {
        if isFinished {
            return .finished
        }
        if myScore == nil {
            return .start
        }
        if isDisabled || userId == "" || userId != myScore!.userId {
            return .disabled
        }
        return myScore!.hasScore() ? .progress : .start
    }
    */
    
    var hasScore: Bool {
        if myScore != nil {
            return myScore!.hasScore()
        }
        return false
    }
    
    func togglePlay () {
        playMe.toggle()
    }
    
    static let defaultGameSizeX = 6
    static let defaultGameSizeY = 2
    static let defaultGameCells = "OOOOIIIISSSS"
    
    static func defaultGame () -> CloseItGame {
        let dataBoard = CloseItDataBoard(program: "", type: "", version: "", group: "", id: "", designer: "", sizeX: defaultGameSizeX, sizeY: defaultGameSizeY, cells: defaultGameCells)
        let game = CloseItGame(dataBoard: dataBoard, challenge: "", level: 0, availableAfterDays: 0)
        
        return game
    }
    
    func copyScores (copyMyScore: inout CloseItScore?, copyOtherScore: inout CloseItScore?) {
        if myScore != nil {
            if copyMyScore != nil {
                copyMyScore!.copy(score: myScore!, withoutRestartsUndosReods: true)
            }
            else {
                copyMyScore = CloseItScore(score: myScore!)
            }
        }
        else {
            copyMyScore = nil
        }
        if otherScore != nil {
            if copyOtherScore != nil {
                copyOtherScore!.copy(score: otherScore!, withoutRestartsUndosReods: true)
            }
            else {
                copyOtherScore = CloseItScore(score: otherScore!)
            }
        }
        else {
            copyOtherScore = nil
        }
    }
        
    func pasteScore (pasteMyScore: CloseItScore?, pasteOtherScore: CloseItScore?) {
        if pasteMyScore != nil {
            if myScore != nil {
                myScore!.copy(score: pasteMyScore!, withoutRestartsUndosReods: true)
            }
            else {
                myScore = CloseItScore(score: pasteMyScore!)
            }
            myScore!.gameId = id
        }
        else {
            myScore = nil
        }
        if pasteOtherScore != nil {
            if otherScore != nil {
                otherScore!.copy(score: pasteOtherScore!, withoutRestartsUndosReods: true)
            }
            else {
            otherScore = CloseItScore(score: pasteOtherScore!)
            }
            otherScore!.gameId = id
        }
        else {
            otherScore = nil
        }
    }

/*    func copyBoardAndScores (game: CloseItGame) {
        isFinished = game.isFinished
        mode = game.mode
        board.copy(board: game.board)
        CloseItScore.copy(from: game.scores, to: &scores)
        resetScores()
        currentScore = game.currentScore
    }
*/
    func setMultiUser (userId: String) {
        otherScore = CloseItScore(userId: userId, gameId: id, boardId: board.boardId, boardName: board.boardName, numSelectableCells: board.numSelectableCells(), target: board.target, challenge: board.challenge, level: board.level)
        mode = .isMultiUser
    }
    
    func sleep () {
        if sleepSeconds > 0.0 {
            if !Thread.isMainThread {
                Thread.sleep(forTimeInterval: sleepSeconds)
            }
        }
    }

    func toggleIsAutoClose () {
        isAutoClose.toggle()
    }
    
    func setUser (user: CloseItUser) {
        if self.userId != user.id {
            self.userId = user.id
            if myScore == nil {
                myScore = CloseItScore(game: self)
                isDisabled = false
            }
            else {
                isDisabled = myScore!.hasScore()
            }
            if !isDisabled {
                myScore!.userId = user.id
                sleepSeconds = user.sleepSeconds
                isAutoClose = user.isAutoClose
            }
        }
    }

    /*
    func getCurrentScore () -> CloseItScore? {
        return (currentScore >= 0 && currentScore < scores.count) ? scores[currentScore] : nil
    }
    */
/*    func nextScore () -> CloseItScore? {
        if mode == .isSingleUser {
            currentScore = 0
            return nil
        }
        if scores.count <= 1 {
            currentScore = 0
            return nil
        }
        if currentScore < scores.count - 1 {
            currentScore += 1
        }
        else {
            currentScore = 0
        }
        return scores[currentScore]
    }
*/
/*    private func getUserMaxSelected (maxSelected: inout Int, wonScores: inout [CloseItScore], notWonScores: inout [CloseItScore]) {
        maxSelected = 0
        for s in scores {
            if s.numSelectedCells > maxSelected {
                maxSelected = s.numSelectedCells
            }
        }
        for s in scores {
            if s.numSelectedCells == maxSelected {
                wonScores.append(s)
            }
            else {
                notWonScores.append(s)
            }
        }
    }
*/
    private func setCan () {
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                canUndo = !isFinished && actions.canUndo
                canRedo = !isFinished && actions.canRedo
            }
        }
        else {
            canUndo = !isFinished && actions.canUndo
            canRedo = !isFinished && actions.canRedo
        }
    }
    
    func setObject (obj: CloseItObject, status: CloseItObject.Status, userId: String? = nil) {
        if myScore != nil {
            myScore!.start()
        }
        board.setObject(obj: obj, status: status, userId: userId)
    }

    private func setStepIndex (_ i: Int) {
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                stepsIndex = i
            }
        }
    }

    
    private func addStepIndex (_ i: Int) {
        setStepIndex(stepsIndex + i)
    }

    func doNextAction () {
        actions.doNext()
    }
    
    func doAllActions () {
        actions.doAll()
        setStepIndex(steps.count)
    }
    
    func doNextStepActions () {
        if stepsIndex < steps.count {
            var i = steps[stepsIndex]
            
            while i > 0 {
                doNextAction()
                i -= 1
            }
            addStepIndex(1)
        }
    }
    
    func doPreviousAction () {
        actions.doPrevious()
    }
    
    func doPreviousStepActions () {
        if stepsIndex > 0 {
            var i = steps[stepsIndex - 1]

            while i > 0 {
                doPreviousAction()
                i -= 1
            }
            addStepIndex(-1)
        }
    }

    func undoAllActions () {
        actions.undoAll()
        setStepIndex(0)
    }
    
    var isFirstAction: Bool {
        return actions.isFirstAction
    }
    
    var isLastAction: Bool {
        return actions.isLastAction
    }
    
    func setupReview () {
        let dataGame = data()
        
        board.reset()
        setReviewActions(encodedStr: dataGame.actions, doActions: true)
        mode = .isReview
    }
        
    func won () {
        if myScore == nil {
            myMessage.warning("myScore == nil")
        }
        else if mode == .isSingleUser || otherScore == nil {
            myScore!.setWon(won: true)
        }
        else {
            let won = myScore! > otherScore!
            
            myScore!.setWon(won: won)
            otherScore!.setWon(won: !won)
        }
        isFinished = true
        setCan()
    }
    
    private func reset () {
        id = UUID()
        isDisabled = false
        board.reset()
        resetScores()
        actions.reset()
        setCan()
    }

    func restart () {
        if myScore != nil {
            if isFinished {
                myScore!.data.numRestarts = 0
                myScore!.data.numUndos = 0
                myScore!.data.numRedos = 0
                myScore!.data.startTimestamp = Date()
            }
            else {
                myScore!.incNumRestarts()
            }
        }
        isFinished = false
        reset()
    }
    
    func doit (action: CloseItAction) {
        CLOSEIT_TYPE_FUNC_START(self)
        actions.doit(action: action)
        setCan()
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func undoit () {
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                if myScore != nil {
                    myScore!.incNumUndos()
                }
            }
        }
        actions.undoit()
        self.setCan()
    }
    
    func redoit () {
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                if myScore != nil {
                    myScore!.incNumRedos()
                }
            }
        }
        actions.redoit()
        setCan()
    }
    
    func data () -> CloseItDataGame {
        var d: CloseItDataGame
        let s = actions.logData()
        
        d = CloseItDataGame(id: id, userId: userId, boardId: board.boardId, boardSizeX: board.sizeX, boardSizeY: board.sizeY, boardCells: board.cellsBoardData(), target: board.target, challenge: board.challenge, level: board.level, actions: s)
        return d
    }
}
