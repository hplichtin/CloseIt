//
//  CloseItAchievement_Test.swift
//  CloseItTests
//
//  Created by Hans-Peter Lichtin on 13.06.2024.
//

import XCTest
@testable import CloseIt

final class CloseItAchievements_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnit() throws {
        var i: Int
        var j: Int
        
        let as1 = CloseItAchievements()
        
        i = 0
        for t1 in CloseItAchievementType.allCases {
            let a1 = CloseItAchievement(userId: "userId\(i)", achievementType: t1, achievementValue: i)
            
            // objects, count, append, contains
            XCTAssert(as1.count == i)
            XCTAssert(as1.contains(userId: "userId\(i)", achievement: a1) == as1.count)
            as1.append(achievement: a1)
            XCTAssert(as1.objects[i] == a1)
            XCTAssert(as1.count == i + 1)
            j = 0
            while j <= i {
                XCTAssert(as1.objects[j].userId == "userId\(j)")
                XCTAssert(as1.objects[j].achievementValue == j)
                let a2 = CloseItAchievement(achievement:  as1.objects[j])
                let a3 = CloseItAchievement(userId: "userId", achievementType: t1, achievementValue: j)
                let a4 = CloseItAchievement( achievementType: t1, achievementValue: j)

                XCTAssert(as1.contains(userId: as1.objects[j].userId, achievement: as1.objects[j]) == j)
                XCTAssert(as1.contains(userId: a3.userId, achievement: as1.objects[j]) == as1.count)
                XCTAssert(as1.contains(userId: a4.userId, achievement: as1.objects[j]) == as1.count)
                XCTAssert(as1.contains(userId: a2.userId, achievement: a2) == j)
                XCTAssert(as1.contains(userId: a3.userId, achievement: a2) == as1.count)
                XCTAssert(as1.contains(userId: a4.userId, achievement: a3) == as1.count)
                XCTAssert(as1.contains(userId: a3.userId, achievement: a3) == as1.count)
                XCTAssert(as1.contains(userId: a4.userId, achievement: a4) == as1.count)
                j += 1
            }
            
            // numAchievements

            let as2 = CloseItAchievements()
            
            let a5 = CloseItAchievement(userId: "userId", achievementType: t1, achievementValue: i)
            let a6 = CloseItAchievement(userId: "userId\(i)", achievementType: t1, achievementValue: i)
            as2.append(achievement: a5)
            as2.append(achievement: a6)
            XCTAssert(as2.numAchievements(userId: "userId") == 1)
            XCTAssert(as2.numAchievements(userId: "userId\(i)") == 1)

            j = 0
            while j <= i {
                let a7 = CloseItAchievement(userId: "userId", achievementType: t1, achievementValue: j)
                let a8 = CloseItAchievement(userId: "userId\(j)", achievementType: t1, achievementValue: j)

                as2.append(achievement: a7)
                as2.append(achievement: a8)
                XCTAssert(as2.numAchievements(userId: "userId") == j + 2)
                if i == j {
                    XCTAssert(as2.numAchievements(userId: "userId\(j)") == 2)
                }
                else {
                    XCTAssert(as2.numAchievements(userId: "userId\(j)") == 1)
                }
                j += 1
            }
            i += 1
        }
        
        // load, store: not tested
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
