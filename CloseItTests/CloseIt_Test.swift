//
//  CloseIt_Test.swift
//  CloseItTests
//
//  Created by Hans-Peter Lichtin on 21.08.2024.
//

import XCTest
@testable import CloseIt

final class CloseIt_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        let appName = Bundle.main.appName
        XCTAssert(CloseIt.program == appName!)
        XCTAssert(!CloseIt.program.isEmpty)

        let appVersion = Bundle.main.releaseVersionNumber
        XCTAssert(CloseIt.version == appVersion!)
        XCTAssert(!CloseIt.version.isEmpty)
        
        let buildVersion = Bundle.main.buildVersionNumber
        XCTAssert(CloseIt.build == buildVersion!)
        XCTAssert(!CloseIt.build.isEmpty)
    }

    func testUnit() throws {}

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
