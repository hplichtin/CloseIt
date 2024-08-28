//
//  CloseItControl_Test.swift
//  CloseItTests
//
//  Created by Hans-Peter Lichtin on 13.06.2024.
//

import XCTest
@testable import CloseIt

final class CloseItControl_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnit() throws {
        let control = CloseItControl(reset: true)
        var count: Int
        var io: Int
        
        // targetAchievements, userAchievements
        XCTAssert(control.resources.userAchievements.count == 0)
        for t1 in CloseItAchievementType.allCases {
            count = 0
            io = 0
            for o in control.resources.targetAchievements.objects {
                XCTAssert(!o.achieved)
                XCTAssert(o.userId == "")
                if io == 0 {
                    XCTAssert(o.nextUserAchievement)
                }
                else if o.achievementType != control.resources.targetAchievements.objects[io - 1].achievementType {
                    XCTAssert(o.nextUserAchievement)
                }
                else {
                    XCTAssert(!o.nextUserAchievement)
                }
                if o.achievementType == t1 {
                    count += 1
                }
                io += 1
            }
            XCTAssert(count > 0)
        }
        // processAchievements
        XCTAssert(!control.processAchievements())
        count = control.resources.numChallenges + 10
        for o in control.resources.targetAchievements.objects {
            if o.achievementType != .allChallengesAtLevelCompleted {
                o.data.achievementValue = count
                count += 10
            }
        }
        control.resources.numChallenges = count
        count += 10
        control.resources.numBoards = count
        count = 0
        io = 0
        for o in control.resources.targetAchievements.objects {
            XCTAssert(o.userId == "")
            if o.achievementType == .allChallengesAtLevelCompleted {
                let level = control.applicationLevel
                
                control.resources.challengeGames.achievedObjects.numCompleted = control.resources.challengeGames.achievedObjects.num - 1
                XCTAssert(!control.processAchievements())
                control.resources.challengeGames.achievedObjects.numCompleted += 1
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.processAchievements())
                XCTAssert(o.achieved)
                XCTAssert(o.userId == control.applicationCurrentUser!.id)
                XCTAssert(!o.nextUserAchievement)
                XCTAssert(control.achievementViewData.hasAchievement)
                XCTAssert(control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.achievementViewData.achievement == o)
                XCTAssert(control.achievementViewData.achievement.achieved)
                XCTAssert(control.achievementViewData.achievement.userId == o.userId)
                XCTAssert(control.achievementViewData.achievement.achievementType == o.achievementType)
                XCTAssert(control.achievementViewData.achievement.achievementValue == o.achievementValue)
                XCTAssert(control.achievementViewData.achievementGroup.num == control.resources.challengeGames.achievedObjects.num)
                XCTAssert(control.achievementViewData.achievementGroup.numCompleted == control.resources.challengeGames.achievedObjects.numCompleted)
                if io < control.resources.targetAchievements.objects.count - 1 {
                    if o.achievementType != control.resources.targetAchievements.objects[io + 1].achievementType {
                        XCTAssert(control.resources.targetAchievements.objects[io + 1].nextUserAchievement)
                    }
                }
                count += 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                if level == control.getMaxLevel().level {
                    if control.applicationLevel != level {
                        myMessage.log("control.applicationLevel != level: control.applicationLevel = \(control.applicationLevel); level = \(level)")
                    }
                    XCTAssert(control.applicationLevel == level)
                }
                else {
                    if control.applicationLevel != level + 1 {
                        myMessage.log("control.applicationLevel != level + 1: control.applicationLevel = \(control.applicationLevel); level + 1 = \(level + 1)")
                    }
                    XCTAssert(control.applicationLevel == level + 1)
                }
                XCTAssert(control.resources.userAchievements.count == count)
                if count == control.resources.userAchievements.count {
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achieved)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].userId == o.userId)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementType == o.achievementType)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementValue == o.achievementValue)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementValue == level)
                }
                else {
                    XCTAssert(false)
                }
            }
            io += 1
        }
        io = 0
        for o in control.resources.targetAchievements.objects {
            switch o.achievementType {
            case .numChallengesPlayed:
                XCTAssert(!o.achieved)
                XCTAssert(o.userId == "")
                control.resources.challengeGames.achievedScores.numPlayed = o.achievementValue - 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                control.resources.challengeGames.achievedScores.numPlayed += 1
                XCTAssert(control.processAchievements())
                XCTAssert(o.achieved)
                XCTAssert(o.userId == control.applicationCurrentUser!.id)
                XCTAssert(!o.nextUserAchievement)
                XCTAssert(control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(control.achievementViewData.hasAchievementGames)
                XCTAssert(control.achievementViewData.achievement == o)
                XCTAssert(control.achievementViewData.achievement.achieved)
                XCTAssert(control.achievementViewData.achievement.userId == o.userId)
                XCTAssert(control.achievementViewData.achievement.achievementType == o.achievementType)
                XCTAssert(control.achievementViewData.achievement.achievementValue == o.achievementValue)
                XCTAssert(control.achievementViewData.achievementGames.numPlayed == control.resources.challengeGames.achievedScores.numPlayed)
                XCTAssert(control.achievementViewData.achievementGames.numCompleted == control.resources.challengeGames.achievedScores.numCompleted)
                if io < control.resources.targetAchievements.objects.count - 1 {
                    if o.achievementType != control.resources.targetAchievements.objects[io + 1].achievementType {
                        XCTAssert(control.resources.targetAchievements.objects[io + 1].nextUserAchievement)
                    }
                }
                count += 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.resources.userAchievements.count == count)
                if count == control.resources.userAchievements.count {
                    XCTAssert(control.resources.userAchievements.objects[count - 1].userId == control.applicationCurrentUser!.id)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementType == o.achievementType)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementValue == o.achievementValue)
                }
                else {
                    XCTAssert(false)
                }
            case .numChallengesCompleted:
                XCTAssert(!o.achieved)
                XCTAssert(o.userId == "")
                control.resources.challengeGames.achievedObjects.num = 2 * o.achievementValue
                control.resources.challengeGames.achievedObjects.numCompleted = o.achievementValue - 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                control.resources.challengeGames.achievedObjects.numCompleted += 1
                XCTAssert(control.processAchievements())
                XCTAssert(o.achieved)
                XCTAssert(o.userId == control.applicationCurrentUser!.id)
                XCTAssert(!o.nextUserAchievement)
                XCTAssert(control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.achievementViewData.achievement == o)
                XCTAssert(control.achievementViewData.achievement.achieved)
                XCTAssert(control.achievementViewData.achievement.userId == o.userId)
                XCTAssert(control.achievementViewData.achievement.achievementType == o.achievementType)
                XCTAssert(control.achievementViewData.achievement.achievementValue == o.achievementValue)
                XCTAssert(control.achievementViewData.achievementGroup.num == control.resources.challengeGames.achievedObjects.num)
                XCTAssert(control.achievementViewData.achievementGroup.numCompleted == control.resources.challengeGames.achievedObjects.numCompleted)
                if io < control.resources.targetAchievements.objects.count - 1 {
                    if o.achievementType != control.resources.targetAchievements.objects[io + 1].achievementType {
                        XCTAssert(control.resources.targetAchievements.objects[io + 1].nextUserAchievement)
                    }
                }
                count += 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.resources.userAchievements.count == count)
                if count == control.resources.userAchievements.count {
                    XCTAssert(control.resources.userAchievements.objects[count - 1].userId == control.applicationCurrentUser!.id)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementType == o.achievementType)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementValue == o.achievementValue)
                }
                else {
                    XCTAssert(false)
                }
            case .allChallengesAtLevelCompleted:
                XCTAssert(true)
            case .numBoardsPlayed:
                XCTAssert(!o.achieved)
                XCTAssert(o.userId == "")
                control.resources.boardGames.achievedScores.numPlayed = o.achievementValue - 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                control.resources.boardGames.achievedScores.numPlayed += 1
                XCTAssert(control.processAchievements())
                XCTAssert(o.achieved)
                XCTAssert(o.userId == control.applicationCurrentUser!.id)
                XCTAssert(!o.nextUserAchievement)
                XCTAssert(control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(control.achievementViewData.hasAchievementGames)
                XCTAssert(control.achievementViewData.achievement == o)
                XCTAssert(control.achievementViewData.achievement.achieved)
                XCTAssert(control.achievementViewData.achievement.userId == o.userId)
                XCTAssert(control.achievementViewData.achievement.achievementType == o.achievementType)
                XCTAssert(control.achievementViewData.achievement.achievementValue == o.achievementValue)
                XCTAssert(control.achievementViewData.achievementGames.numPlayed == control.resources.boardGames.achievedScores.numPlayed)
                XCTAssert(control.achievementViewData.achievementGames.numCompleted == control.resources.boardGames.achievedScores.numCompleted)
                if io < control.resources.targetAchievements.objects.count - 1 {
                    if o.achievementType != control.resources.targetAchievements.objects[io + 1].achievementType {
                        XCTAssert(control.resources.targetAchievements.objects[io + 1].nextUserAchievement)
                    }
                }
                count += 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.resources.userAchievements.count == count)
                if count == control.resources.userAchievements.count {
                    XCTAssert(control.resources.userAchievements.objects[count - 1].userId == control.applicationCurrentUser!.id)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementType == o.achievementType)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementValue == o.achievementValue)
                }
                else {
                    XCTAssert(false)
                }
            case .numBoardsCompleted:
                XCTAssert(!o.achieved)
                XCTAssert(o.userId == "")
                control.resources.boardGames.achievedObjects.num = 2 * o.achievementValue
                control.resources.boardGames.achievedObjects.numCompleted = o.achievementValue - 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                control.resources.boardGames.achievedObjects.numCompleted += 1
                XCTAssert(control.processAchievements())
                XCTAssert(o.achieved)
                XCTAssert(o.userId == control.applicationCurrentUser!.id)
                XCTAssert(!o.nextUserAchievement)
                XCTAssert(control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.achievementViewData.achievement == o)
                XCTAssert(control.achievementViewData.achievement.achieved)
                XCTAssert(control.achievementViewData.achievement.userId == o.userId)
                XCTAssert(control.achievementViewData.achievement.achievementType == o.achievementType)
                XCTAssert(control.achievementViewData.achievement.achievementValue == o.achievementValue)
                XCTAssert(control.achievementViewData.achievementGroup.num == control.resources.boardGames.achievedObjects.num)
                XCTAssert(control.achievementViewData.achievementGroup.numCompleted == control.resources.boardGames.achievedObjects.numCompleted)
                if io < control.resources.targetAchievements.objects.count - 1 {
                    if o.achievementType != control.resources.targetAchievements.objects[io + 1].achievementType {
                        XCTAssert(control.resources.targetAchievements.objects[io + 1].nextUserAchievement)
                    }
                }
                count += 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.resources.userAchievements.count == count)
                if count == control.resources.userAchievements.count {
                    XCTAssert(control.resources.userAchievements.objects[count - 1].userId == control.applicationCurrentUser!.id)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementType == o.achievementType)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementValue == o.achievementValue)
                }
                else {
                    XCTAssert(false)
                }
            case .numBoardGroupsCompleted:
                XCTAssert(!o.achieved)
                XCTAssert(o.userId == "")
                control.resources.boardGames.achievedGroups.num = 2 * o.achievementValue
                control.resources.boardGames.achievedGroups.numCompleted = o.achievementValue - 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                control.resources.boardGames.achievedGroups.numCompleted += 1
                XCTAssert(control.processAchievements())
                XCTAssert(o.achieved)
                XCTAssert(o.userId == control.applicationCurrentUser!.id)
                XCTAssert(!o.nextUserAchievement)                
                XCTAssert(control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.achievementViewData.achievement == o)
                XCTAssert(control.achievementViewData.achievement.achieved)
                XCTAssert(control.achievementViewData.achievement.userId == o.userId)
                XCTAssert(control.achievementViewData.achievement.achievementType == o.achievementType)
                XCTAssert(control.achievementViewData.achievement.achievementValue == o.achievementValue)
                XCTAssert(control.achievementViewData.achievementGroup.num == control.resources.boardGames.achievedGroups.num)
                XCTAssert(control.achievementViewData.achievementGroup.numCompleted == control.resources.boardGames.achievedGroups.numCompleted)
                if io < control.resources.targetAchievements.objects.count - 1 {
                    if o.achievementType != control.resources.targetAchievements.objects[io + 1].achievementType {
                        XCTAssert(control.resources.targetAchievements.objects[io + 1].nextUserAchievement)
                    }
                }
                count += 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.resources.userAchievements.count == count)
                if count == control.resources.userAchievements.count {
                    XCTAssert(control.resources.userAchievements.objects[count - 1].userId == control.applicationCurrentUser!.id)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementType == o.achievementType)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementValue == o.achievementValue)
                }
                else {
                    XCTAssert(false)
                }
            case .numDaysPlayed:
                XCTAssert(!o.achieved)
                XCTAssert(o.userId == "")
                
                let calendar = Calendar.current
                control.resources.startDatePlayed = Date()
                control.resources.endDatePlayed = calendar.date(byAdding: .day, value: o.achievementValue - 1, to: control.resources.startDatePlayed)!
                XCTAssert(control.numDaysPlayed == o.achievementValue - 1)
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                control.resources.endDatePlayed = calendar.date(byAdding: .day, value: o.achievementValue, to: control.resources.startDatePlayed)!
                XCTAssert(control.numDaysPlayed == o.achievementValue)
                XCTAssert(control.processAchievements())
                XCTAssert(o.achieved)
                XCTAssert(o.userId == control.applicationCurrentUser!.id)
                XCTAssert(!o.nextUserAchievement)
                XCTAssert(control.achievementViewData.hasAchievement)
                XCTAssert(control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.achievementViewData.achievement == o)
                XCTAssert(control.achievementViewData.achievement.userId == o.userId)
                XCTAssert(control.achievementViewData.achievement.achievementType == o.achievementType)
                XCTAssert(control.achievementViewData.achievement.achievementValue == o.achievementValue)
                XCTAssert(control.achievementViewData.achievementGroup.num == control.resources.challengeGames.achievedObjects.num)
                myMessage.log(control.achievementViewData.achievementGroup.num.description)
                myMessage.log(control.resources.challengeGames.achievedObjects.num.description)
                XCTAssert(control.achievementViewData.achievementGroup.numCompleted == control.resources.challengeGames.achievedObjects.numCompleted)
                if io < control.resources.targetAchievements.objects.count - 1 {
                    if o.achievementType != control.resources.targetAchievements.objects[io + 1].achievementType {
                        XCTAssert(control.resources.targetAchievements.objects[io + 1].nextUserAchievement)
                    }
                }
                count += 1
                XCTAssert(!control.processAchievements())
                XCTAssert(!control.achievementViewData.hasAchievement)
                XCTAssert(!control.achievementViewData.hasOldAchievementGroup)
                XCTAssert(!control.achievementViewData.hasNewAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGroup)
                XCTAssert(!control.achievementViewData.hasAchievementGames)
                XCTAssert(control.resources.userAchievements.count == count)
                if count == control.resources.userAchievements.count {
                    XCTAssert(control.resources.userAchievements.objects[count - 1].userId == control.applicationCurrentUser!.id)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementType == o.achievementType)
                    XCTAssert(control.resources.userAchievements.objects[count - 1].achievementValue == o.achievementValue)
                }
                else {
                    XCTAssert(false)
                }

            }
            io += 1
        }
        XCTAssert(control.resources.userAchievements.count == control.resources.targetAchievements.count)
        for o in control.resources.targetAchievements.objects {
            XCTAssert(o.achieved)
            XCTAssert(o.userId == control.applicationCurrentUser!.id)
            let i = control.resources.userAchievements.contains(userId: control.applicationCurrentUser!.id, achievement: o)
            XCTAssert(i >= 0 && i < control.resources.userAchievements.count)
            XCTAssert(o.userId == control.resources.userAchievements.objects[i].userId)
            XCTAssert(o.achievementType == control.resources.userAchievements.objects[i].achievementType)
            XCTAssert(o.achievementValue == control.resources.userAchievements.objects[i].achievementValue)
            XCTAssert(o.data.achievementDate == control.resources.userAchievements.objects[i].data.achievementDate)
        }
        for o in control.resources.userAchievements.objects {
            XCTAssert(o.achieved)
            XCTAssert(o.userId == control.applicationCurrentUser!.id)
            let i = control.resources.targetAchievements.contains(userId: control.applicationCurrentUser!.id, achievement: o)
            XCTAssert(i >= 0 && i < control.resources.targetAchievements.count)
            XCTAssert(o.userId == control.resources.targetAchievements.objects[i].userId)
            XCTAssert(o.achievementType == control.resources.targetAchievements.objects[i].achievementType)
            XCTAssert(o.achievementValue == control.resources.targetAchievements.objects[i].achievementValue)
            XCTAssert(o.data.achievementDate == control.resources.targetAchievements.objects[i].data.achievementDate)
        }
        // switch user
        let oldUser = control.applicationCurrentUser!
        
        if control.resources.users.count == 1 {
            let user = CloseItUser(id: "USERID")
            control.resources.users.append(user: user)
        }
        XCTAssert(control.resources.users.count > 1)
        for u in control.resources.users.users {
            if u.id != oldUser.id {
                control.resources.startDatePlayed = Date()
                control.resources.endDatePlayed = control.resources.startDatePlayed
                control.setCurrentUser(userId: u.id)
                for o in control.resources.targetAchievements.objects {
                    XCTAssert(!o.achieved)
                    XCTAssert(o.userId == "")
                    var i = control.resources.userAchievements.contains(userId: u.id, achievement: o)
                    XCTAssert(i == control.resources.userAchievements.count)
                    i = control.resources.userAchievements.contains(userId: oldUser.id, achievement: o)
                    XCTAssert(i >= 0 && i < control.resources.userAchievements.count)
                    XCTAssert(control.resources.userAchievements.objects[i].userId == oldUser.id)
                    XCTAssert(o.achievementType == control.resources.userAchievements.objects[i].achievementType)
                    XCTAssert(o.achievementValue == control.resources.userAchievements.objects[i].achievementValue)
                }
                control.setCurrentUser(userId: oldUser.id)
                XCTAssert(control.resources.userAchievements.count == control.resources.targetAchievements.count)
                for o in control.resources.targetAchievements.objects {
                    XCTAssert(o.achieved)
                    XCTAssert(o.userId == control.applicationCurrentUser!.id)
                    let i = control.resources.userAchievements.contains(userId: control.applicationCurrentUser!.id, achievement: o)
                    XCTAssert(i >= 0 && i < control.resources.userAchievements.count)
                    XCTAssert(o.userId == control.resources.userAchievements.objects[i].userId)
                    XCTAssert(o.achievementType == control.resources.userAchievements.objects[i].achievementType)
                    XCTAssert(o.achievementValue == control.resources.userAchievements.objects[i].achievementValue)
                    XCTAssert(o.data.achievementDate == control.resources.userAchievements.objects[i].data.achievementDate)
                }
                for o in control.resources.userAchievements.objects {
                    XCTAssert(o.achieved)
                    XCTAssert(o.userId == control.applicationCurrentUser!.id)
                    let i = control.resources.targetAchievements.contains(userId: control.applicationCurrentUser!.id, achievement: o)
                    XCTAssert(i >= 0 && i < control.resources.targetAchievements.count)
                    XCTAssert(o.userId == control.resources.targetAchievements.objects[i].userId)
                    XCTAssert(o.achievementType == control.resources.targetAchievements.objects[i].achievementType)
                    XCTAssert(o.achievementValue == control.resources.targetAchievements.objects[i].achievementValue)
                    XCTAssert(o.data.achievementDate == control.resources.targetAchievements.objects[i].data.achievementDate)
                }
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
