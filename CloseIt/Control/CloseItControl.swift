//
//  CloseItControl.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 24.11.21.
//

import Foundation
import UIKit
import SwiftUI

final class CloseItControl: CloseItLog, ObservableObject {
    ///
    /// Constants
    ///
    
    static let levelStart: Level = 0
    static let levelEnd: Level = 11
    
    ///
    /// Resources
    ///
    class Resources: CloseItLog {
        static let doneGamesURL: URL = CloseItData.getURL(userDomainFileName: CloseItDataGame.type + "-" + CloseItDataGame.version)
        static let demoGamesURL: URL = CloseItData.getURL(bundleFileName: "DemoGames" + "-" + CloseItDataGame.version)
        
        static var defaultDesignId: String {
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
                return "default" // "default.phone"
            }
            else {
                return "default"
            }
        }
        
        static let doneGamesGroup = "Done Games"
        static let demoGamesGroup = "Demo Games"
        
        var config: CloseItDataConfig
        var features: [CloseItDataFeature] = []
        var incidents: [CloseItDataIndicent] = []
        var designs: [CloseItDesign] = []
        var users = CloseItUsers()
        var boardGames = CloseItGamesGroup()
        var challengeGames = CloseItGamesGroup()
        var doneGames: CloseItGames
        var boardScores = CloseItBoardScores()
        var demoGames: CloseItGames
        var demos: CloseItDemos
        @Published var dataControl = CloseItDataControl()
        
        var dataBoards: [CloseItDataBoard] = []
        var dataChallenges: [CloseItDataChallenge] = []
        
        var levels: CloseItLevels
        
        var player: CloseItPlayer
        
        var userAchievements: CloseItAchievements = CloseItAchievements()
        
        var targetAchievements: CloseItAchievements
        var numChallengeGroups: Int = 0
        var numChallenges: Int = 0
        var numBoardGroups: Int = 0
        var numBoards: Int = 0
        var startDatePlayed: Date = Date()
        var endDatePlayed: Date = Date()
        
        init () {
            // config
            config = CloseItDataConfig.load()
            player = CloseItPlayer()
            // level, achievemets: .AllChallengesAtLevelCompleted
            levels = CloseItLevels()
            targetAchievements = CloseItAchievements()
            var level = CloseItControl.levelStart
            while level <= CloseItControl.levelEnd {
                levels.append(level: CloseItLevel(data: CloseItDataLevel(level: level)))
                targetAchievements.append(achievement: CloseItAchievement(achievementType: .allChallengesAtLevelCompleted, achievementValue: level))
                level += 1
            }
            // demos
            demos = CloseItDemos()
            // games
            doneGames = CloseItGames(url: Resources.doneGamesURL)
            demoGames = CloseItGames(url: Resources.demoGamesURL)
            // features
            CloseItDataFeature.load(data: &features)
            // incidents
            CloseItDataIndicent.load(data: &incidents)
            // designs
            CloseItDesign.load(objects: &designs)
            // boards & challenges
            CloseItDataCollection.load(url: CloseItData.getURL(bundleFileName: CloseItDataCollection.type), dataBoards: &dataBoards, dataChallenges: &dataChallenges)
            boardGames.add(dataBoards: dataBoards)
            challengeGames.add(dataChallenges: dataChallenges, dataBoards: dataBoards)
            numChallengeGroups = challengeGames.data.count
            numChallenges = dataChallenges.count
            numBoardGroups = boardGames.data.count
            numBoards = dataBoards.count
            // users
            users.load()
            // player
            if !player.isAuthenticated {
                player.authenticate()
            }
            // dataControl
            _ = dataControl.load()
            // load games
            doneGames.load(group: Resources.doneGamesGroup, doActions: true, mode: .isReview)
            demoGames.load(group: Resources.demoGamesGroup, doActions: false, mode: .inDemo)
            // update demos with games
            demos.setGames(games: demoGames)
            // user achievements
            userAchievements.load()
            // scores
            initScores()
            // set startDatePlayed
            for bs in boardScores.data {
                for s in bs.scores {
                    if s.startTimestamp < startDatePlayed {
                        startDatePlayed = s.startTimestamp
                    }
                    if s.endTimestamp > endDatePlayed {
                        endDatePlayed = s.endTimestamp
                    }
                }
            }
            // add target achievements
            addTargetAchievements(numChallenges: numChallenges, numBoardGroups: numBoardGroups, numBoards: numBoards)
        }
        
        func initScores () {
            var scores: [CloseItScore] = []
            
            CloseItScore.load(objects: &scores)
            boardScores = CloseItBoardScores()
            boardScores.add(scores: scores)
            boardScores.rankScores()
            boardScores.setGames(gamesArray: doneGames)
        }
        
        static func doReset (reset: Bool = CloseItControl.Application.reset) {
            CLOSEIT_FUNC_START()
            if reset {
                struct Data {
                    var type: String
                    var version: String
                    
                    init (_ type: String, _ version: String) {
                        self.type = type
                        self.version = version
                    }
                }
                
                let types: [Data] = [ 
                    Data(CloseItDataUser.type, CloseItDataUser.version),
                    Data(CloseItDataScore.type, CloseItDataScore.version),
                    Data(CloseItDataGame.type, CloseItDataGame.version),
                    Data(CloseItDataAchievement.type, CloseItDataAchievement.version),
                    Data(CloseItDataControl.type, CloseItDataControl.version)
                ]
                
                myMessage.debug("reset")
                for t in types {
                    CloseItData.removeFile(userDomainFileName: t.type + "-" + t.version)
                }
            }
            CLOSEIT_FUNC_END()
        }
        
        func reset (reset: Bool = CloseItControl.Application.reset) {
            CLOSEIT_FUNC_START()
            users.reset()
            doneGames = CloseItGames()
            boardScores = CloseItBoardScores()
            dataControl = CloseItDataControl()
            CloseItControl.Resources.doReset(reset: reset)
            boardGames.restartGames()
            challengeGames.restartGames()
            initScores()
            CLOSEIT_FUNC_END()
        }
        
        func storeGames () {
            doneGames.store()
        }
        
        func storeControl () {
            dataControl.store()
        }
        
        private func addTargetAchievements (numChallenges: Int, numBoardGroups: Int, numBoards: Int) {
            CLOSEIT_TYPE_FUNC_START(self)
            
            let numPlayed = [ 15, 30, 50, 75, 100, 150, 200, 250, 300, 400, 500, 750, 1000, 2500, 5000, 10000 ]
            let numCompleted = [ 10, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 300, 400, 500, 600, 700, 800, 900, 1000 ]
            
            for n in numPlayed {
                targetAchievements.append(achievement: CloseItAchievement(achievementType: .numChallengesPlayed, achievementValue: n))
            }
            for n in numPlayed {
                targetAchievements.append(achievement: CloseItAchievement(achievementType: .numBoardsPlayed, achievementValue: n))
            }
            for n in numCompleted {
                if n < numChallenges {
                    targetAchievements.append(achievement: CloseItAchievement(achievementType: .numChallengesCompleted, achievementValue: n))
                }
            }
            targetAchievements.append(achievement: CloseItAchievement(achievementType: .numChallengesCompleted, achievementValue: numChallenges))
            for n in numCompleted {
                if n < numBoards {
                    targetAchievements.append(achievement: CloseItAchievement(achievementType: .numBoardsCompleted, achievementValue: n))
                }
            }
            targetAchievements.append(achievement: CloseItAchievement(achievementType: .numBoardsCompleted, achievementValue: numBoards))
            
            var i = 0
            while i < numBoardGroups {
                targetAchievements.append(achievement: CloseItAchievement(achievementType: .numBoardGroupsCompleted, achievementValue: i + 1))
                i += 1
            }
            
            var availableAfterDays: [Int] = []
            
            for c in dataChallenges {
                let a = c.availableAfterDays
                
                if a != 0 {
                    let i = availableAfterDays.firstIndex(of: a)
                    
                    if i == nil {
                        availableAfterDays.append(a)
                        targetAchievements.append(achievement: CloseItAchievement(achievementType: .numDaysPlayed, achievementValue: a))
                    }
                }
            }
            
            CLOSEIT_TYPE_FUNC_END(self)
        }
    }
    
    var resources: Resources
    
    var numDaysPlayed: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: resources.startDatePlayed, to: resources.endDatePlayed)
        return (components.day ?? 0)
    }
    
    func availableAt (numDays: Int) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: numDays, to: resources.startDatePlayed)
        return newDate!
    }
    
    func getDesign (designId: String) -> CloseItDesign {
        for d in resources.designs {
            if d.id == designId {
                return d
            }
        }
        myMessage.error("CloseItControl.getDesign: designId '\(designId)' unknown")
    }
    
    func setCurrentUser (user: CloseItUser, store: Bool) {
        CLOSEIT_TYPE_FUNC_START(self, " user.id: '\(user.id)'")
        let i = resources.config.adminUserIds.firstIndex(of: user.id)
        applicationAdmin = i != nil
        if applicationAdmin {
            myMessage.log("admin == \(applicationAdmin)")
        }
        if applicationCurrentUser == nil || applicationCurrentUser!.id != user.id {
            resources.boardGames.setUser(user: user)
            resources.challengeGames.setUser(user: user)
            if store && resources.dataControl.currentUserId != user.id {
                resources.dataControl.currentUserId = user.id
                resources.storeControl()
            }
            applicationCurrentUser = user
            if applicationLevel != user.level {
                let maxLevel = getMaxLevel().level
                if user.level <= maxLevel {
                    applicationLevel = user.level
                }
                else {
                    user.data.level = maxLevel
                    applicationLevel = maxLevel
                }
            }
            setAchievementsForNewUser()
            calculateGoals()
            if processAchievements(reset: false) {
                showAchievementView()
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func setCurrentUser (userId: String) {
        CLOSEIT_TYPE_FUNC_START(self, " userId: '\(userId)'")
        let u: Int = resources.users.find(userId: userId)
        var store = false
        
        if u >= resources.users.count {
            let user = CloseItUser(id: userId)
            
            store = true
            resources.users.append(user: user)
        }
        setCurrentUser(user: resources.users[u], store: store)
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func addPlayerToUsers () {
        CLOSEIT_TYPE_FUNC_START(self)
        var index: Int
        var user: CloseItUser
        
        index = resources.users.find(userId: resources.player.id)
        if index >= 0 && index < resources.users.count {
            user = resources.users.users[index]
            user.set(player: resources.player)
        }
        else {
            user = CloseItUser(player: resources.player)
            resources.users.append(user: user)
        }
        myMessage.debug("resources.player.id: \(resources.player.id); resources.dataControl.currentUserId: \(resources.dataControl.currentUserId)")
        if resources.dataControl.currentUserId == "" {
            setCurrentUser(user: user, store: true)
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func setSleepSeconds (sleepSeconds: Double) {
        CLOSEIT_TYPE_FUNC_START(self, " \(sleepSeconds)")
        for dg in resources.boardGames.data {
            for d in dg.games.data {
                d.game.sleepSeconds = sleepSeconds
            }
        }
        for dg in resources.challengeGames.data {
            for d in dg.games.data {
                d.game.sleepSeconds = sleepSeconds
            }
        }
        for d in resources.demoGames.data {
            d.game.sleepSeconds = sleepSeconds
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func getBoard (boardId: String) -> CloseItBoard? {
        let board = resources.boardGames.getBoard(boardId: boardId)
        
        return board
    }
    
    func getBoardName (boardId: String) -> String {
        var boardName: String
        
        boardName = resources.boardGames.getBoardName(boardId: boardId)
        if boardName == "" {
            boardName = resources.doneGames.getBoardName(boardId: boardId)
        }
        return boardName
    }
    
    func getLevel (level: Int) -> CloseItLevel {
        CLOSEIT_TYPE_FUNC_START(self)
        let l = resources.levels.getLevel(level: level)
        
        CLOSEIT_TYPE_FUNC_END(self)
        return l
    }
    
    func getMaxLevel () -> CloseItLevel {
        CLOSEIT_TYPE_FUNC_START(self)
        let l = resources.levels.getMaxLevel()
        
        CLOSEIT_TYPE_FUNC_END(self)
        return l
    }
    
    ///
    /// User Interface
    ///
    
    class UserInterface {
        static let startSystemImageName = "info.square.fill"
        static let checkSystemImageName = "checkmark.circle"
        static let uncheckSystemImageName = "circle"
        static let boardSystemImageName = "square.grid.2x2"
        static let challengeSystemImageName = "checkmark.square"
        static let challengeOpenSystemImageName = "square"
        static let usersSystemImageName = "person.crop.circle"
        static let adminSystemImageName = "gearshape.circle"
        static let newUserSystemImageName = "person.badge.plus"
        static let expandSystemImageName = "plus.circle"
        static let collapseSystemImageName = "minus.circle"
        static let currentUserSystemImageName = "person.fill.checkmark"
        static let notCurrentUserSystemImageName = "person"
        static let currentSystemImageName = "checkmark.circle"
        static let notCurrentSystemImageName = "circle"
        static let closeSystemImageName = "x.circle"
        static let helpShowSystemImageName = "questionmark.circle.fill"
        static let helpHideSystemImageName = "questionmark.circle"
        static let showAllScoresSystemImageName = "line.3.horizontal.circle.fill"
        static let hideAllScoresSystemImageName = "line.3.horizontal.circle"
        
        var keyWindow: UIWindow? = nil
    }
    
    var userInterface: UserInterface
    
    static func getCheckImageName (isChecked: Bool) -> String {
        return isChecked ? CloseItControl.UserInterface.checkSystemImageName : CloseItControl.UserInterface.uncheckSystemImageName
    }
    
    static func getCurrentUserImageName (isCurrent: Bool) -> String {
        return isCurrent ? CloseItControl.UserInterface.currentUserSystemImageName : CloseItControl.UserInterface.notCurrentUserSystemImageName
    }
    
    static func getCheckUserImageName (isCheck: Bool) -> String  {
        return isCheck ? CloseItControl.UserInterface.checkSystemImageName : CloseItControl.UserInterface.uncheckSystemImageName
    }
    
    static func getChallengeImageName (isCompleted: Bool) -> String {
        return isCompleted ? CloseItControl.UserInterface.challengeSystemImageName : CloseItControl.UserInterface.challengeOpenSystemImageName
    }
    
    static func getHelpImageName (help: Bool) -> String {
        return help ? CloseItControl.UserInterface.helpHideSystemImageName : CloseItControl.UserInterface.helpShowSystemImageName
    }
    
    static func getShowAllImageName (showAll: Bool) -> String {
        return showAll ? CloseItControl.UserInterface.hideAllScoresSystemImageName : CloseItControl.UserInterface.showAllScoresSystemImageName
    }
    
    ///
    /// Application
    ///
    ///
    
    @Published var applicationZoom: Double
    
    @Published var publishedScoreBoards: String = ""
    @Published var publishedScoreChallenges: String = ""
    
    struct AchievementApplicationData {
        private var privateAchievement: CloseItAchievement? = nil
        private var privateOldAchievementGroup: CloseItAchievementGroup? = nil
        private var privateNewAchievementGroup: CloseItAchievementGroup? = nil
        private var privateAchievementGames: CloseItAchievementGames? = nil
        
        mutating func reset () {
            privateAchievement = nil
            privateOldAchievementGroup = nil
            privateNewAchievementGroup = nil
            privateAchievementGames = nil
        }
        
        var hasAchievement: Bool {
            return privateAchievement != nil
        }
        
        var achievement: CloseItAchievement {
            get {
                return privateAchievement!
            }
            set {
                privateAchievement = newValue
            }
        }
        
        var hasOldAchievementGroup: Bool {
            return privateOldAchievementGroup != nil
        }
        
        var oldAchievementGroup: CloseItAchievementGroup {
            get {
                return privateOldAchievementGroup!
            }
            set {
                privateOldAchievementGroup = newValue
            }
        }
        
        var hasNewAchievementGroup: Bool {
            return privateNewAchievementGroup != nil
        }
        
        var newAchievementGroup: CloseItAchievementGroup {
            get {
                return privateNewAchievementGroup!
            }
            set {
                privateNewAchievementGroup = newValue
            }
            
        }
        
        var hasAchievementGroup: Bool {
            return privateNewAchievementGroup != nil
        }
        
        var achievementGroup: CloseItAchievementGroup {
            get {
                return privateNewAchievementGroup!
            }
            set {
                privateNewAchievementGroup = newValue
            }
        }
        
        var hasAchievementGames: Bool {
            return privateAchievementGames != nil
        }
        
        var achievementGames: CloseItAchievementGames {
            get {
                return privateAchievementGames!
            }
            set {
                privateAchievementGames = newValue
            }
        }
        
        var numNew: Int {
            newAchievementGroup.num - oldAchievementGroup.num
        }
    }
    
    @Published var achievementViewData = AchievementApplicationData()
    
    func setNewLevelOfCurrenUser (level: Level) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(applicationCurrentUser != nil)
        
        applicationCurrentUser!.data.level = level
        storeUsers()
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    private func processAchievementCompleted (achievement: CloseItAchievement) {
        CLOSEIT_TYPE_FUNC_START(self)
        
        achievementViewData.reset()
        achievementViewData.achievement = achievement
        switch achievement.achievementType {
        case .numChallengesPlayed:
            achievementViewData.achievementGames = resources.challengeGames.achievedScores
        case .numChallengesCompleted:
            achievementViewData.achievementGroup = resources.challengeGames.achievedObjects
        case .allChallengesAtLevelCompleted:
            achievementViewData.oldAchievementGroup = resources.challengeGames.achievedObjects
            if applicationLevel < getMaxLevel().level {
                applicationLevel += 1
                calculateGoals()
            }
            achievementViewData.newAchievementGroup = resources.challengeGames.achievedObjects
            setNewLevelOfCurrenUser(level: applicationLevel)
        case .numBoardsPlayed:
            achievementViewData.achievementGames = resources.boardGames.achievedScores
        case .numBoardsCompleted:
            achievementViewData.newAchievementGroup = resources.boardGames.achievedObjects
        case .numBoardGroupsCompleted:
            achievementViewData.newAchievementGroup = resources.boardGames.achievedGroups
        case .numDaysPlayed:
            achievementViewData.oldAchievementGroup = resources.challengeGames.achievedObjects
            calculateGoals()
            achievementViewData.newAchievementGroup = resources.challengeGames.achievedObjects
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    private func checkAchievementCompleted (achievement: CloseItAchievement) -> Bool {
        CLOSEIT_TYPE_FUNC_START(self)
        var c: Bool
        
        switch achievement.achievementType {
        case .numChallengesPlayed:
            c = resources.challengeGames.achievedScores.numPlayed >= achievement.achievementValue
        case .numChallengesCompleted:
            c = resources.challengeGames.achievedObjects.numCompleted >= achievement.achievementValue
        case .allChallengesAtLevelCompleted:
            c = resources.challengeGames.achievedObjects.completed
        case .numBoardsPlayed:
            c = resources.boardGames.achievedScores.numPlayed >= achievement.achievementValue
        case .numBoardsCompleted:
            c = resources.boardGames.achievedObjects.numCompleted >= achievement.achievementValue
        case .numBoardGroupsCompleted:
            c = resources.boardGames.achievedGroups.numCompleted >= achievement.achievementValue
        case .numDaysPlayed:
            c = numDaysPlayed >= achievement.achievementValue
        }
        CLOSEIT_TYPE_FUNC_END(self)
        return c
    }
    
    func numAchievementCompleted (achievement: CloseItAchievement) -> Int {
        CLOSEIT_TYPE_FUNC_START(self)
        var num: Int
        
        switch achievement.achievementType {
        case .numChallengesPlayed:
            num = resources.challengeGames.achievedScores.numPlayed
        case .numChallengesCompleted:
            num = resources.challengeGames.achievedObjects.numCompleted
        case .allChallengesAtLevelCompleted:
            num = resources.challengeGames.achievedObjects.numCompleted
        case .numBoardsPlayed:
            num = resources.boardGames.achievedScores.numPlayed
        case .numBoardsCompleted:
            num = resources.boardGames.achievedObjects.numCompleted
        case .numBoardGroupsCompleted:
            num = resources.boardGames.achievedGroups.numCompleted
        case .numDaysPlayed:
            num = numDaysPlayed
        }
        CLOSEIT_TYPE_FUNC_END(self)
        return num
    }
    
    func processAchievements (reset: Bool = true) -> Bool {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(applicationCurrentUser != nil)
        var completed = false
        
        if reset {
            achievementViewData.reset()
        }
        for o in resources.targetAchievements.objects {
            if !o.achieved {
                if checkAchievementCompleted(achievement: o) {
                    o.achieved(userId: applicationCurrentUser!.id)
                    
                    let a = CloseItAchievement(achievement: o)
                    
                    processAchievementCompleted(achievement: a)
                    resources.userAchievements.append(achievement: a)
                    resources.userAchievements.store()
                    completed = true
                    break
                }
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
        return completed
    }
    
    func setAchievementsForNewUser () {
        CLOSEIT_TYPE_FUNC_START(self)
        var index = 0
        
        resources.targetAchievements.reset()
        for o in resources.targetAchievements.objects {
            let i = resources.userAchievements.contains(userId: applicationCurrentUser!.id, achievement: o)
            if i >= 0 && i < resources.userAchievements.count {
                o.data.userId = applicationCurrentUser!.id
                o.data.achievementDate = resources.userAchievements.objects[i].data.achievementDate
                o.nextUserAchievement = false
            }
            else if index > 0 {
                if o.achievementType != resources.targetAchievements.objects[index - 1].achievementType {
                    o.nextUserAchievement = true
                }
                else if resources.targetAchievements.objects[index - 1].achieved {
                    o.nextUserAchievement = true
                }
            }
            else {
                o.nextUserAchievement = true
            }
            index += 1
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func addScoreToAchievements (score: CloseItScore) {
        if score.isBoard {
            resources.boardGames.updateAchievements(score: score)
            publishedScoreBoards = resources.boardGames.achievedObjects.score
        }
        else if score.isChallenge {
            resources.challengeGames.updateAchievements(score: score)
            publishedScoreChallenges = resources.challengeGames.achievedObjects.score
        }
        else {
            abort()
        }
        // check achievements
        if processAchievements() {
            showAchievementView()
        }
    }

    private func calculateGoals () {
        CLOSEIT_TYPE_FUNC_START(self)
        if applicationCurrentUser != nil {
            let numDaysPlayed = numDaysPlayed
            
            resources.boardGames.calculateAchievements(userId: applicationCurrentUser!.id, boardScores: resources.boardScores, level: applicationLevel, numDaysPlayed: numDaysPlayed)
            resources.challengeGames.calculateAchievements(userId: applicationCurrentUser!.id, boardScores: resources.boardScores, level: applicationLevel, numDaysPlayed: numDaysPlayed)
            //            DispatchQueue.main.sync {
            self.publishedScoreBoards = resources.boardGames.achievedObjects.score
            self.publishedScoreChallenges = resources.challengeGames.achievedObjects.score
        }
        else {
            myMessage.error("applicationCurrentUser == nil")
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }

    enum ApplicationView: String {
        case infoApplicationView = "infoApplicationView"
        case challengesApplicationView = "challengesApplicationView"
        case boardsApplicationView = "boardsApplicationView"
        case usersApplicationView = "usersApplicationView"
        case adminApplicationView = "adminApplicationView"
        case scoreApplicationView = "scoreApplicationView"
        case achievementApplicationView = "achievementApplicationView"
    }
    
    var applicationInit: Bool = false
    var _applicationBusy: Bool = false
    var oldApplicationView: [ApplicationView] = []
    @Published var applicationView: ApplicationView = .infoApplicationView
    
    @Published var applicationCurrentScore: CloseItScore? = nil
    @Published var applicationCurrentUser: CloseItUser? = nil
    
    @Published var applicationLevel: Level = 0
    @Published var applicationDebug: Bool = false
    @Published var applicationAdmin: Bool = false
    @Published var applicationShowAll: Bool = true
    
    func applicationBusy (_ busy: Bool) {
        CLOSEIT_TYPE_FUNC_START(self)
        _applicationBusy = busy
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    var applicationBusy: Bool {
        return _applicationBusy
    }
    
    private func setApplicationView (data: CloseItDataControl) {
        CLOSEIT_TYPE_FUNC_START(self)
        if data.applicationView != "" {
            let av = ApplicationView(rawValue: data.applicationView)
            
            if av == nil {
                myMessage.error("undexpected applicationView '\(data.applicationView)'")
            }
            else if isMainApplicationView(applicationView: av!) {
                applicationView = av!
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func storeControlDataApplicationView (applicationView: ApplicationView) {
        CLOSEIT_TYPE_FUNC_START(self)
        if isMainApplicationView(applicationView: applicationView) && resources.dataControl.applicationView != applicationView.rawValue {
            resources.dataControl.applicationView = applicationView.rawValue
            resources.storeControl()
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    private func changeApplicationView (applicationView: ApplicationView) {
        CLOSEIT_TYPE_FUNC_START(self)
        if self.applicationView != applicationView {
            oldApplicationView.append(self.applicationView)
            self.applicationView = applicationView
        }
        if isMainApplicationView(applicationView: applicationView) {
            storeControlDataApplicationView(applicationView: applicationView)
        }
        CLOSEIT_TYPE_FUNC_END(self, " -> \(self.applicationView)")
    }
    
    private func closeApplicationView () {
        CLOSEIT_TYPE_FUNC_START(self)
        
        if oldApplicationView.count == 0 {
            myMessage.warning("oldApplicationView.count == 0")
        }
        else {
            let newApplicationView = oldApplicationView.last!
            
            oldApplicationView.removeLast()
            if isMainApplicationView(applicationView: applicationView) {
                storeControlDataApplicationView(applicationView: applicationView)
            }
            if applicationView != newApplicationView {
                applicationView = newApplicationView
            }
        }
        CLOSEIT_TYPE_FUNC_END(self, " -> \(self.applicationView)")
    }
    
    private func showAchievementView () {
        CLOSEIT_TYPE_FUNC_START(self)
        changeApplicationView(applicationView: .achievementApplicationView)
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func closeAchievementView () {
        CLOSEIT_TYPE_FUNC_START(self)
        closeApplicationView()
        if processAchievements() {
            showAchievementView()
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    private func showScoreApplicationView () {
        CLOSEIT_TYPE_FUNC_START(self)
        if applicationCurrentScore != nil {
            changeApplicationView(applicationView: .scoreApplicationView)
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func closeScoreApplicationView () {
        CLOSEIT_TYPE_FUNC_START(self)
        closeApplicationView()
        CLOSEIT_TYPE_FUNC_END(self)
    }
        
    func isMainApplicationView (applicationView: ApplicationView) -> Bool {
        CLOSEIT_TYPE_FUNC_START(self)
        
        var isMain: Bool

        switch applicationView {
        case .infoApplicationView, .challengesApplicationView, .boardsApplicationView, .usersApplicationView, .adminApplicationView: isMain = true
        default: isMain = false
        }
        CLOSEIT_TYPE_FUNC_END(self)
        return isMain
    }
    
    class Application {
        static var reset = false
    }
    
    var application: Application

    private func wonGame (game: CloseItGame) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(applicationCurrentUser != nil, "applicationCurrentUser == nil")
        
        var storedGame: CloseItGame? = nil
        
        game.won()
        storedGame = CloseItGame(game: game, newId: false, reviewGame: true)
        resources.doneGames.append(game: storedGame!)
        resources.storeGames()
        if game.myScore != nil {
            let score = CloseItScore(score: game.myScore!)
            
            if score.startTimestamp < resources.startDatePlayed {
                resources.startDatePlayed = score.startTimestamp
            }
            if score.endTimestamp > resources.endDatePlayed {
                resources.endDatePlayed = score.endTimestamp
            }
            storedGame!.myScore = score
            score.game = storedGame
            score.isGameStored = true
            resources.boardScores.add(score: score, onlyHasScore: true)
            resources.boardScores.rankScores()
            game.myScore!.groupRank = score.groupRank
            game.myScore!.scoreRank = score.scoreRank
            resources.boardScores.store()
            addScoreToAchievements(score: score)
            storeControlDataApplicationView(applicationView: applicationView)
        }
        else {
            game.myScore = nil
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    private func doActionSelectGameLine (game: CloseItGame, obj: CloseItObject, source: CloseItActionData.Source) {
        CLOSEIT_TYPE_FUNC_START(self, " obj: \(obj.data())")
        precondition(applicationCurrentUser != nil)
        
        let action = CloseItActionSelectLine(game: game, user: self.applicationCurrentUser!, obj: obj, source: source)
        game.doit(action: action)
        if source == .isUserAction {
            game.lastLine = obj
        }
        if game.isAutoClose && obj.isSelected {
            // close cells
            let maxSelectedLines = game.board.maxCellCloseItCount()
            
            if obj.isLineY{
                // left cell
                if game.board.getCellLinesSelectedOrBorderCount(x: obj.x - 1, y: obj.y) == maxSelectedLines && !game.board.cells[obj.x - 1][obj.y].isSelected {
                    doActionSelectGameCell(game: game, obj: game.board.cells[obj.x - 1][obj.y], source: .isAutoAction)
                }
                // right cell
                if game.board.getCellLinesSelectedOrBorderCount(x: obj.x, y: obj.y) == maxSelectedLines && !game.board.cells[obj.x][obj.y].isSelected {
                    doActionSelectGameCell(game: game, obj: game.board.cells[obj.x][obj.y], source: .isAutoAction)
                }
            }
            else {
                precondition(obj.isLineX)
                // above cell
                if game.board.getCellLinesSelectedOrBorderCount(x: obj.x, y: obj.y) == maxSelectedLines && !game.board.cells[obj.x][obj.y].isSelected {
                    doActionSelectGameCell(game: game, obj: game.board.cells[obj.x][obj.y], source: .isAutoAction)
                }
                // below cell
                if game.board.getCellLinesSelectedOrBorderCount(x: obj.x, y: obj.y - 1) == maxSelectedLines && !game.board.cells[obj.x][obj.y - 1].isSelected {
                    self.doActionSelectGameCell(game: game, obj: game.board.cells[obj.x][obj.y - 1], source: .isAutoAction)
                }
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }

    func selectGameLine (game: CloseItGame, obj: CloseItObject) {
        CLOSEIT_TYPE_FUNC_START(self, " obj: \(obj.data())")
        let oldLastLine = game.lastLine
        
        if game.isProcessing {
            return
        }
        game.isProcessing = true
        applicationBusy(true)
        DispatchQueue.global(qos: .userInteractive).async {
            self.doActionSelectGameLine(game: game, obj: obj, source: .isUserAction)
            if game.isAutoClose && oldLastLine != nil && obj.status == oldLastLine!.status {
                var ll = oldLastLine!
                var x, y: Int
                
                if ll.isLineX && obj.isLineX && ll.y == obj.y || ll.isLineY && obj.isLineX && (ll.y == obj.y || ll.y + 1 == obj.y) || ll.isLineX && obj.isLineY && (ll.y - 1 == obj.y || ll.y == obj.y) {
                    if ll.isLineX == obj.isLineX {
                        x = ll.x + 1
                        y = ll.y
                    }
                    else if ll.isLineY { // && obj.isLineX
                        x = ll.x
                        y = obj.y
                    }
                    else { // ll.isLineX && obj.isLineY
                        x = ll.x + 1
                        y = ll.y
                    }
                    while x < obj.x {
                        ll = game.board.linesX[x][y]
                        x += 1
                        if ll.isSelectable && ll.status != obj.status {
                            self.doActionSelectGameLine(game: game, obj: ll, source: .isAutoAction)
                        }
                    }
                    if ll.isLineX == obj.isLineX {
                        x = ll.x - 1
                        y = ll.y
                    }
                    else if ll.isLineY { // && obj.isLineX
                        x = ll.x - 1
                        y = obj.y
                    }
                    else { // ll.isLineX && obj.isLineY
                        x = ll.x
                        y = ll.y
                    }
                    while x >= obj.x {
                        ll = game.board.linesX[x][y]
                        x -= 1
                        if ll.isSelectable && ll.status != obj.status {
                            self.doActionSelectGameLine(game: game, obj: ll, source: .isAutoAction)
                        }
                    }
                }
                else if ll.isLineY && obj.isLineY && ll.x == obj.x || ll.isLineX && obj.isLineY && (ll.x == obj.x || ll.x + 1 == obj.x) || ll.isLineY && obj.isLineX && (ll.x - 1 == obj.x || ll.x == obj.x) {
                    if ll.isLineY == obj.isLineY {
                        x = ll.x
                        y = ll.y + 1
                    }
                    else if ll.isLineX { // && obj.isLineY
                        x = obj.x
                        y = ll.y
                    }
                    else { // ll.isLineY && obj.isLineX
                        x = ll.x
                        y = ll.y + 1
                    }
                    while y < obj.y {
                        ll = game.board.linesY[x][y]
                        y += 1
                        if ll.isSelectable && ll.status != obj.status {
                            self.doActionSelectGameLine(game: game, obj: ll, source: .isAutoAction)
                        }
                    }
                    if ll.isLineY == obj.isLineY {
                        x = ll.x
                        y = ll.y - 1
                    }
                    else if ll.isLineX { // && obj.isLineY
                        x = obj.x
                        y = ll.y - 1
                    }
                    else { // ll.isLineY && obj.isLineX
                        x = ll.x
                        y = ll.y
                    }
                    while y >= obj.y {
                        ll = game.board.linesY[x][y]
                        y -= 1
                        if ll.isSelectable && ll.status != obj.status {
                            self.doActionSelectGameLine(game: game, obj: ll, source: .isAutoAction)
                        }
                    }
                }
            }
            DispatchQueue.main.sync {
                if !game.isFinished && game.board.areAllCellsSelected() {
                    self.wonGame(game: game)
                }
                game.isProcessing = false
                self.applicationBusy(false)
           }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func selectLineNearCell (game: CloseItGame, obj: CloseItObject, size: CGFloat, x: CGFloat, y: CGFloat) {
        CLOSEIT_TYPE_FUNC_START(self, " \(size) \(x):\(y)")
    
        let lineXbelow = game.board.linesX[obj.x][obj.y]
        let lineXabove = game.board.linesX[obj.x][obj.y + 1]
        let lineYleft = game.board.linesY[obj.x][obj.y]
        let lineYright = game.board.linesY[obj.x + 1][obj.y]
        
        let gapBelow = size - y
        let gapAbove = y
        let gapLeft = x
        let gapRight = size - x
        
        if gapBelow < gapAbove && gapBelow < gapLeft && gapBelow < gapRight {
            if lineXbelow.isSelectable {
                selectGameLine(game: game, obj: lineXbelow)
            }
        }
        else if gapAbove < gapLeft && gapAbove < gapRight {
            if lineXabove.isSelectable {
                selectGameLine(game: game, obj: lineXabove)
            }
        }
        else if gapLeft < gapRight {
            if lineYleft.isSelectable {
                selectGameLine(game: game, obj: lineYleft)
            }
        }
        else {
            if lineYright.isSelectable {
                selectGameLine(game: game, obj: lineYright)
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func doActionSelectGameCell (game: CloseItGame, obj: CloseItObject, source: CloseItActionData.Source) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(applicationCurrentUser != nil)
        
        let action = CloseItActionSelectCell(game: game, user: self.applicationCurrentUser!, obj: obj, source: source)
        game.doit(action: action)
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func selectGameCell (game: CloseItGame, obj: CloseItObject) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(applicationCurrentUser != nil)
        
        var source: CloseItActionData.Source = .isUserAction
        var cell: CloseItObject? = obj
        
        if game.isProcessing {
            return
        }
        game.isProcessing = true
        applicationBusy(true)
        game.lastLine = nil
        DispatchQueue.global(qos: .userInteractive).async {
            let maxSelectedLines = game.board.maxCellCloseItCount()

            while cell != nil {
                self.doActionSelectGameCell(game: game, obj: cell!, source: source)
                if game.isAutoClose {
                    var linesSelected = 0
                    
                    source = .isAutoAction
                    game.sleep()
                    linesSelected = game.board.getCellLinesSelectedOrBorderCount(x: cell!.x, y: cell!.y)
                    if linesSelected == maxSelectedLines - 1 || linesSelected == maxSelectedLines - 2 {
                        // left cell
                        if cell!.x < game.board.sizeX - 1 && !game.board.cells[cell!.x + 1][cell!.y].isSelected && game.board.linesY[cell!.x + 1][cell!.y].isIn {
                            if game.board.cells[cell!.x + 1][cell!.y].isSelectable {
                                cell = game.board.cells[cell!.x + 1][cell!.y]
                            }
                            else {
                                self.doActionSelectGameLine(game: game, obj: game.board.linesY[cell!.x + 1][cell!.y], source: source)
                                cell = nil
                            }
                        }
                        // right cell
                        else if cell!.x > 0 && !game.board.cells[cell!.x - 1][cell!.y].isSelected && game.board.linesY[cell!.x][cell!.y].isIn {
                            if game.board.cells[cell!.x - 1][cell!.y].isSelectable {
                                cell = game.board.cells[cell!.x - 1][cell!.y]
                            }
                            else {
                                self.doActionSelectGameLine(game: game, obj: game.board.linesY[cell!.x][cell!.y], source: source)
                                cell = nil

                            }
                        }
                        // top cell
                        else if cell!.y < game.board.sizeY - 1 && !game.board.cells[cell!.x][cell!.y + 1].isSelected && game.board.linesX[cell!.x][cell!.y + 1].isIn {
                            if game.board.cells[cell!.x][cell!.y + 1].isSelectable {
                                cell = game.board.cells[cell!.x][cell!.y + 1]
                            }
                            else {
                                self.doActionSelectGameLine(game: game, obj: game.board.linesX[cell!.x][cell!.y + 1], source: source)
                                cell = nil
                            }
                        }
                        // bottom cell
                        else if cell!.y > 0 && !game.board.cells[cell!.x][cell!.y - 1].isSelected && game.board.linesX[cell!.x][cell!.y].isIn {
                            if game.board.cells[cell!.x][cell!.y - 1].isSelectable {
                                cell = game.board.cells[cell!.x][cell!.y - 1]
                            }
                            else {
                                self.doActionSelectGameLine(game: game, obj: game.board.linesX[cell!.x][cell!.y], source: source)
                                cell = nil
                            }
                        }
                        else {
                            cell = nil
                        }
                    }
                    else {
                        cell = nil
                    }
                }
                else {
                    cell = nil
                }
            }
            DispatchQueue.main.sync {
                if !game.isFinished && game.board.areAllCellsSelected() {
                    self.wonGame(game: game)
                }
                self.applicationBusy(false)
                game.isProcessing = false
           }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
  
    func undo (game: CloseItGame) {
        CLOSEIT_TYPE_FUNC_START(self)
        
        if game.isProcessing {
            return
        }
        game.lastLine = nil
        game.isProcessing = true
        applicationBusy(true)
        DispatchQueue.global(qos: .userInteractive).async {
            game.undoit()
            DispatchQueue.main.sync {
                game.isProcessing = false
                self.applicationBusy(false)
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
   }
   
   func redo (game: CloseItGame) {
       CLOSEIT_TYPE_FUNC_START(self)
       
       if game.isProcessing {
           return
       }
       game.lastLine = nil
       game.isProcessing = true
       applicationBusy(true)
       DispatchQueue.global(qos: .userInteractive).async {
           game.redoit()
           DispatchQueue.main.sync {
               game.isProcessing = false
               self.applicationBusy(false)
           }
       }
       CLOSEIT_TYPE_FUNC_END(self)
   }
    
    func zoomMinus () {
        if resources.dataControl.zoom >= 2.0 {
            resources.dataControl.zoom -= 1.0
        }
        else {
            resources.dataControl.zoom = resources.dataControl.zoom / 2.0
        }
        resources.storeControl()
        applicationZoom = resources.dataControl.zoom
    }
    
    func zoomPlus () {
        if resources.dataControl.zoom >= 1.0 {
            resources.dataControl.zoom += 1.0
        }
        else {
            resources.dataControl.zoom = resources.dataControl.zoom * 2.0
        }
        resources.storeControl()
        applicationZoom = resources.dataControl.zoom
    }
    
    func restartGame (game: CloseItGame) {
        game.lastLine = nil
        game.restart()
    }
        
    func toggleIsAutoClose (game: CloseItGame) {
        game.toggleIsAutoClose()
    }
    
    func doPreviousAction (game: CloseItGame) {
        CLOSEIT_TYPE_FUNC_START(self)
        
        if game.isProcessing {
            return
        }
        game.isProcessing = true
        applicationBusy(true)
        DispatchQueue.global(qos: .userInteractive).async {
            game.doPreviousAction()
            DispatchQueue.main.sync {
                game.isProcessing = false
                self.applicationBusy(false)
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func doNextAction (game: CloseItGame) {
        CLOSEIT_TYPE_FUNC_START(self)
        
        if game.isProcessing {
            return
        }
        game.isProcessing = true
        applicationBusy(true)
        DispatchQueue.global(qos: .userInteractive).async {
            game.doNextAction()
            DispatchQueue.main.sync {
                game.isProcessing = false
                self.applicationBusy(false)
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }

    func undoAllActions (game: CloseItGame) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(applicationCurrentUser != nil)

        if game.isProcessing {
            return
        }
        game.isProcessing = true
        game.isAutoClose = applicationCurrentUser!.isAutoClose
        game.isProcessing = true
        applicationBusy(true)
        DispatchQueue.global(qos: .userInteractive).async {
            game.undoAllActions()
            DispatchQueue.main.sync {
                game.isProcessing = false
                self.applicationBusy(false)
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func doAllActions (game: CloseItGame) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(applicationCurrentUser != nil)

        game.isAutoClose = applicationCurrentUser!.isAutoClose
        game.isProcessing = true
        applicationBusy(true)
        DispatchQueue.global(qos: .userInteractive).async {
            game.doAllActions()
            DispatchQueue.main.sync {
                game.isProcessing = false
                self.applicationBusy(false)
            }
        }
    }
    
    func doPreviousStepActions (game: CloseItGame) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(applicationCurrentUser != nil)

        if game.isProcessing {
            return
        }
        game.isAutoClose = applicationCurrentUser!.isAutoClose
        game.isProcessing = true
        applicationBusy(true)
        DispatchQueue.global(qos: .userInteractive).async {
            game.doPreviousStepActions()
            DispatchQueue.main.sync {
                game.isProcessing = false
                self.applicationBusy(false)
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func doNexStepActions (game: CloseItGame) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(applicationCurrentUser != nil)

        game.isAutoClose = applicationCurrentUser!.isAutoClose
        game.isProcessing = true
        applicationBusy(true)
        DispatchQueue.global(qos: .userInteractive).async {
            game.doNextStepActions()
            DispatchQueue.main.sync {
                game.isProcessing = false
                self.applicationBusy(false)
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func loopActions (game: CloseItGame) {
        CLOSEIT_TYPE_FUNC_START(self)
        precondition(applicationCurrentUser != nil)

        if game.isProcessing {
            return
        }
        game.isProcessing = true
        applicationBusy(true)
        DispatchQueue.global(qos: .userInteractive).async {
            repeat {
                game.sleep()
            } while !game.isAutoClose
            repeat {
                game.doAllActions()
                game.sleep()
                game.undoAllActions()
            } while game.isAutoClose
            DispatchQueue.main.sync {
                game.isProcessing = false
                self.applicationBusy(false)
            }
        }
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func reviewGame (game: CloseItGame) {
        CLOSEIT_TYPE_FUNC_START(self)
        
        if game.isFinished {
            let reviewGame = resources.doneGames.getGame(gameId: game.id)
            
            precondition(game.myScore!.gameId == reviewGame.myScore!.gameId)
            applicationShowAll = false
            applicationCurrentScore = reviewGame.myScore
        }
        else {
            applicationShowAll = true
            applicationCurrentScore = game.myScore
            applicationCurrentScore!.game = game
        }
        showViewScoreApplicationView()
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func showViewScoreApplicationView () {
        CLOSEIT_TYPE_FUNC_START(self)
        showScoreApplicationView()
        CLOSEIT_TYPE_FUNC_END(self)
    }
    
    func toggleShowAll () {
        CLOSEIT_TYPE_FUNC_START(self)
        applicationShowAll.toggle()
        CLOSEIT_TYPE_FUNC_END(self, " applicationShowAll = \(applicationShowAll)")
    }
    
    func storeUsers () {
        resources.users.store()
    }
    
    func newUser () {
        let name = "New " + String(resources.users.count + 1)
        let user = CloseItUser(name: name)
        
        resources.users.append(user: user)
        storeUsers()
    }
    
    func deleteUser (userId: String) {
        resources.users.remove(userId: userId)
        storeUsers()
    }
    
    func value (showName: Bool = false, sep: String = CloseIt.separator) -> String {
        var s: String = ""
        
        s += resources.dataControl.value(showName: showName, sep: sep) + sep
        s += ( showName ? "applicationInit:" : "" ) + "\(applicationInit)" + sep
        s += ( showName ? "_applicationBusy:" : "" ) + "\(_applicationBusy)" + sep
        s += ( showName ? "applicationView:" : "" ) + "\(applicationView)" + sep
        s += ( showName ? "applicationCurrentScore.id:" : "" ) + (applicationCurrentScore == nil ? "nil" : "\(applicationCurrentScore!.id)") + sep
        s += ( showName ? "applicationCurrentUser.id:" : "" ) + (applicationCurrentUser == nil ? "nil" : applicationCurrentUser!.id) + sep
        s += ( showName ? "applicationLevel:" : "" ) + "\(applicationLevel)" + sep
        s += ( showName ? "applicationShowAll:" : "" ) + "\(applicationShowAll)" + sep
        s += ( showName ? "applicationZoom:" : "" ) + "\(applicationZoom)" + sep
        s += ( showName ? "publishedScoreBoards:" : "" ) + "\(publishedScoreBoards)" + sep
        s += ( showName ? "publishedScoreChallenges:" : "" ) + "\(publishedScoreChallenges)"
        return s
    }
    
    ///
    /// init
    ///
    
    init(reset: Bool = false) {
        CLOSEIT_FUNC_START()
        CloseItControl.Application.reset = reset
        // do reset if required
        CloseItControl.Resources.doReset()
        // sub-types
        userInterface = UserInterface()
        resources = Resources()
        application = Application()
        // binding vars
        applicationZoom = resources.dataControl.zoom
        setApplicationView(data: resources.dataControl)
        if resources.dataControl.currentUserId == "" {
            setCurrentUser(user: resources.users[0], store: false)
        }
        else {
            setCurrentUser(userId: resources.dataControl.currentUserId)
        }
        // player
        resources.player.setControl(control: self)
        // status
        applicationInit = true
        CLOSEIT_FUNC_END()
    }
}
