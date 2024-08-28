//
//  CloseItAchievement_Test.swift
//  CloseItTests
//
//  Created by Hans-Peter Lichtin on 13.06.2024.
//

import XCTest
@testable import CloseIt

final class CloseItAchievement_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnit() throws {
        var i: Int
        var j: Int
        
        i = 0
        for t1 in CloseItAchievementType.allCases {
            // init, id, userId, achievementType, achievementValue, badgeImageName
            let a1 = CloseItAchievement(userId: "userId", achievementType: t1, achievementValue: i)
            
            XCTAssert(a1.id == "userId|\(t1)|\(i)")
            XCTAssert(a1.userId == "userId")
            XCTAssert(a1.achievementType == t1)
            XCTAssert(a1.achievementValue == i)
            if t1 == .allChallengesAtLevelCompleted {
                XCTAssert(a1.badgeImageName == "level.\(i).badge")
            }
            else {
                XCTAssert(a1.badgeImageName == "achievement.\(t1).\(i).badge")
            }
            
            let d1 = CloseItDataAchievement(achievementType: t1.rawValue, achievementValue: i)
            let a2 = CloseItAchievement(data: d1)
            
            XCTAssert(a2.id == "|\(t1)|\(i)")
            XCTAssert(a2.userId == "")
            XCTAssert(a2.achievementType == t1)
            XCTAssert(a2.achievementValue == i)
            
            let a3 = CloseItAchievement(userId: "\(t1)", achievementType: t1, achievementValue: i)
            let a4 = CloseItAchievement(achievement: a3)
            
            XCTAssert(a4.id == "\(t1)|\(t1)|\(i)")
            XCTAssert(a4.userId == "\(t1)")
            XCTAssert(a4.achievementType == t1)
            XCTAssert(a4.achievementValue == i)
            
            j = 0
            for t2 in CloseItAchievementType.allCases {
                // ==
                let a5 = CloseItAchievement(userId: "\(t1)", achievementType: t1, achievementValue: i)
                let a6 = CloseItAchievement(userId: "\(t2)", achievementType: t2, achievementValue: j)
                if i == j {
                    XCTAssert(a5 == a6)
                }
                else {
                    XCTAssert(!(a5 == a6))
                }
                
                // contains
                if i == j {
                    XCTAssert(a5.contains(userId: a5.userId, achievement: a6))
                    XCTAssert(!a5.contains(userId: "userId", achievement: a6))
                }
                else {
                    XCTAssert(!a5.contains(userId: a5.userId, achievement: a6))
                    XCTAssert(!a5.contains(userId: "userId", achievement: a6))
                }
                j += 1
            }
            
            // load, store: not tested
            // achievementTypeName: not tested
            // value, description: not texted
            
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
