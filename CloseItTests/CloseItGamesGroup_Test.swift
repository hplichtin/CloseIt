//
//  CloseItGamesGroup_Test.swift
//  CloseItTests
//
//  Created by Hans-Peter Lichtin on 20.08.2024.
//

import XCTest
@testable import CloseIt

final class CloseItGamesGroup_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnit() throws {
        let gamesGroup = CloseItGamesGroup()
        var dataBoards: [CloseItDataBoard] = []
        var dataChallenges: [CloseItDataChallenge] = []

        XCTAssert(gamesGroup.data.count == 0)
        CloseItDataCollection.load(url: CloseItData.getURL(bundleFileName: CloseItDataCollection.type), dataBoards: &dataBoards, dataChallenges: &dataChallenges)
        XCTAssert(dataBoards.count > 0)
        XCTAssert(dataChallenges.count > 0)
        gamesGroup.add(dataChallenges: dataChallenges, dataBoards: dataBoards)
        XCTAssert(gamesGroup.data.count > 0)
        
        // test if all challenges are added
        for dc in dataChallenges {
            var added = 0
            for ggd in gamesGroup.data {
                for dg in ggd.games.data {
                    if dc.boardId == dg.game.board.boardId && dc.challenge == dg.game.board.challenge {
                        XCTAssert(dc.level == dg.game.board.level)
                        added += 1
                    }
                }
            }
            XCTAssert(added == 1)
        }
        
        // test if challenges are sorted by level
        for ggd in gamesGroup.data {
            myMessage.log("\(ggd.group)")

            var i = 0
            for gd in ggd.games.data {
                myMessage.log("\(i): \(gd.game.board.boardId) \(gd.game.board.challenge): level:\(gd.game.board.level)")

                let g = gd.game
                i += 1
                if i < ggd.games.data.count {
                    let ng = ggd.games.data[i].game
                    
                    XCTAssert(g.board.level <= ng.board.level)
                    if g.board.level > ng.board.level {
                        myMessage.log("g.board.level > ng.board.level = \(g.board.boardId) \(g.board.challenge):\(g.board.level) > \(ng.board.boardId) \(ng.board.challenge):\(ng.board.level)")
                    }
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
