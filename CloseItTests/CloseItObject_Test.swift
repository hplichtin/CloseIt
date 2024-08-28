//
//  CloseItObject_Test.swift
//  CloseItTests
//
//  Created by Hans-Peter Lichtin on 25.09.22.
//

import XCTest
import Foundation
@testable import CloseIt

class CloseItObject_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnit() throws {
        var obj: CloseItObject
        var i: Int
        
        let x: [Int] = [ -1, 0, +1, 10, 5, 6, 7, 8, 9, 10, 11 ]
        let y: [Int] = [ 10, +1, 0, -1, 11, 10, 9, 8, 7, 6, 5 ]
        let type: [CloseItObject.Object] = [ .isCell, .isCell, .isCell, .isLineX, .isLineX, .isLineX, .isLineX, .isLineY, .isLineY, .isLineY, .isLineY ]
        let status: [CloseItObject.Status] = [ .isSelected, .isIn, .isOut, .isBorder, .isSelected, .isIn, .isOut, .isBorder, .isSelected, .isIn, .isOut ]
        let typeName: [String] = [ "cell", "cell", "cell", "linex", "linex", "linex", "linex", "liney", "liney", "liney", "liney" ]
        let statusValue: [Character] = [ "S", "I", "O", "B", "S", "I", "O", "B", "S", "I", "O" ]
        let statusValueLong: [String] = [ "S1", "I2", "O3", "B4", "S5", "I6", "O7", "B8", "S9", "I10", "O11" ]
        let statusValueError: [String] = [ "A", "C", "X", "", "5", "6", "7", "8", "9", "10", "11" ]
        let statusName: [String] = [ "selected", "in", "out", "border", "selected", "in", "out", "border", "selected", "in", "out" ]
        let userId: [String] = [ "u1", "u2", "u3", "u4", "u5", "u6", "u7", "u8", "u9", "u10", "u11" ]
        let data: [String] = [ "c-1:10", "c0:1", "c1:0", "x10:-1", "x5:11", "x6:10", "x7:9", "y8:8", "y9:7", "y10:6", "y11:5" ]
        let dataDeaign = CloseItDataDesign(program: "", type: "", version: "", id: "", designer: "", size: 8, width: 8, imageCellIn: "imageCellIn", imageCellOut: "imageCellOut", imageCellSelected: "imageCellSelected", imageLineXBorder: "imageLineXBorder", imageLineXIn: "imageLineXIn", imageLineXOut: "imageLineXOut", imageLineXSelected: "imageLineXSelected", imageLineYBorder: "imageLineYBorder", imageLineYIn: "imageLineYIn", imageLineYOut: "imageLineYOut", imageLineYSelected: "imageLineYSelected")
        let imageName: [String] = [ "imageCellSelected",  "imageCellIn", "imageCellOut", "imageLineXBorder", "imageLineXSelected", "imageLineXIn", "imageLineXOut", "imageLineYBorder", "imageLineYSelected", "imageLineYIn", "imageLineYOut" ]
        let str: [String] = [ CloseItObject.strCellSelected, CloseItObject.strCellIn, CloseItObject.strCellOut, CloseItObject.strLineXBorder, CloseItObject.strLineXSelected, CloseItObject.strLineXIn, CloseItObject.strLineXOut, CloseItObject.strLineYBorder, CloseItObject.strLineYSelected, CloseItObject.strLineYIn, CloseItObject.strLineYOut ]
        
        i = 0
        while i < x.count {
            myMessage.debug("CloseItObject_Test.testUnit: i = \(i)")
            
            // static name (type:)
            XCTAssert(CloseItObject.name(type: type[i]) == typeName[i])
 
            // static value
            XCTAssert(CloseItObject.value(status: status[i]) == statusValue[i])
            
            // static name (status:)
            XCTAssert(CloseItObject.name(status: status[i]) == statusName[i])
            
            // static statusFromdString
            XCTAssert(CloseItObject.statusFromStr(statusStr: "\(statusValue[i])") == status[i])
            XCTAssert(CloseItObject.statusFromStr(statusStr: statusValueLong[i]) == status[i])
            XCTAssert(CloseItObject.statusFromStr(statusStr: statusValueError[i]) == CloseItObject.defaultStatus)
            
            // init
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            XCTAssert(obj.x == x[i])
            XCTAssert(obj.y == y[i])
            XCTAssert(obj.type == type[i])
            XCTAssert(obj.status == status[i])
            XCTAssert(obj.userId == nil)

            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i], userId: userId[i])
            XCTAssert(obj.x == x[i])
            XCTAssert(obj.y == y[i])
            XCTAssert(obj.type == type[i])
            XCTAssert(obj.status == status[i])
            XCTAssert(obj.userId! == userId[i])
            
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], statusStr: "\(statusValue[i])")
            XCTAssert(obj.x == x[i])
            XCTAssert(obj.y == y[i])
            XCTAssert(obj.type == type[i])
            XCTAssert(obj.status == status[i])
            XCTAssert(obj.userId == nil)

            obj = CloseItObject(x: x[i], y: y[i], type: type[i], statusStr: "\(statusValue[i])", userId: userId[i])
            XCTAssert(obj.x == x[i])
            XCTAssert(obj.y == y[i])
            XCTAssert(obj.type == type[i])
            XCTAssert(obj.status == status[i])
            XCTAssert(obj.userId == userId[i])
            
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], statusStr: statusValueLong[i], userId: userId[i])
            XCTAssert(obj.x == x[i])
            XCTAssert(obj.y == y[i])
            XCTAssert(obj.type == type[i])
            XCTAssert(obj.status == status[i])
            XCTAssert(obj.userId! == userId[i])

            obj = CloseItObject(x: x[i], y: y[i], type: type[i], statusStr: statusValueError[i])
            XCTAssert(obj.x == x[i])
            XCTAssert(obj.y == y[i])
            XCTAssert(obj.type == type[i])
            XCTAssert(obj.status == CloseItObject.defaultStatus)
            XCTAssert(obj.userId == nil)
            
            if i > 0 {
                var obj2: CloseItObject
                //var uuid: UUID
                
                obj2 = CloseItObject(x: x[i - 1], y: y[i - 1], type: type[i - 1], status: status[i - 1])
                obj = CloseItObject(obj: obj2)
                XCTAssert(obj.id != obj2.id)
                XCTAssert(obj.x == x[i - 1])
                XCTAssert(obj.y == y[i - 1])
                XCTAssert(obj.type == type[i - 1])
                XCTAssert(obj.status == status[i - 1])
                XCTAssert(obj.userId == nil)

                obj2 = CloseItObject(x: x[i - 1], y: y[i - 1], type: type[i - 1], status: status[i - 1], userId: userId[i - 1])
                obj = CloseItObject(obj: obj2)
                XCTAssert(obj.id != obj2.id)
                XCTAssert(obj.x == x[i - 1])
                XCTAssert(obj.y == y[i - 1])
                XCTAssert(obj.type == type[i - 1])
                XCTAssert(obj.status == status[i - 1])
                XCTAssert(obj.userId! == userId[i - 1])
/*
                // type
                obj.type = type[i - 1]
                XCTAssert(obj.type == type[i - 1])
            
                // x
                obj.x = x[i - 1]
                XCTAssert(obj.x == x[i - 1])
 
                // y
                obj.y = y[i - 1]
                XCTAssert(obj.y == y[i - 1])
                
                // copy
                obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
                uuid = obj.id
                obj2 = CloseItObject(x: x[i - 1], y: y[i - 1], type: type[i - 1], status: status[i - 1])
                obj.copy(obj: obj2)
                XCTAssert(obj.id == uuid)
                XCTAssert(obj.id != obj2.id)
                XCTAssert(obj.x == x[i - 1])
                XCTAssert(obj.y == y[i - 1])
                XCTAssert(obj.type == type[i - 1])
                XCTAssert(obj.status == status[i - 1])
                XCTAssert(obj.userId == nil)
*/            } /*
            // user
            obj.userId = userId[i]
            XCTAssert(obj.userId! == userId[i])
            obj.userId = nil
            XCTAssert(obj.userId == nil)
            obj.userId = userId[i]
            XCTAssert(obj.userId! == userId[i])
*/
            // set, get, getStatus
            if i > 0 {
                obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i], userId: userId[i])
                obj.set(status: status[i - 1])
                XCTAssert(obj.status == status[i - 1])
                // print(obj.getStatus())
                // print(String(statusValue[i - 1]))
                XCTAssert(obj.getStatus() == String(statusValue[i - 1]))
                XCTAssert(obj.userId == nil)

                obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
                obj.set(status: status[i - 1], userId: userId[i - 1])
                XCTAssert(obj.status == status[i - 1])
                XCTAssert(obj.getStatus() == String(statusValue[i - 1]))
                XCTAssert(obj.userId == userId[i - 1])
            }

            // reset
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            obj.reset()
            if status[i] == .isSelected {
                XCTAssert(obj.status == .isIn)
            }
            else {
                XCTAssert(obj.status == status[i])
            }
            
            // isCell
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            if type[i] == .isCell {
                XCTAssert(obj.isCell)
            }
            else {
                XCTAssert(!obj.isCell)
            }
            
            // isLineX
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            if type[i] == .isLineX {
                XCTAssert(obj.isLineX)
            }
            else {
                XCTAssert(!obj.isLineX)
            }

            // isLineY
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            if type[i] == .isLineY {
                XCTAssert(obj.isLineY)
            }
            else {
                XCTAssert(!obj.isLineY)
            }
            
            // isLine
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            if type[i] == .isLineX || type[i] == .isLineY {
                XCTAssert(obj.isLine)
            }
            else {
                XCTAssert(!obj.isLine)
            }
            
            // isSelectedOrBorder
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            if (obj.isCell && obj.isSelected) || (obj.isLine && (status[i] == .isSelected || status[i] == .isBorder)) {
                XCTAssert(obj.isSelectedOrBorder == 1)
            }
            else {
                XCTAssert(obj.isSelectedOrBorder == 0)
            }

            // isSelectedOrBorder userId
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            XCTAssert(obj.isSelectedOrBorder(userId: userId[i]) == 0)
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i], userId: userId[i])
            if (obj.isCell && obj.isSelected) || (obj.isLine && (status[i] == .isSelected || status[i] == .isBorder)) {
                XCTAssert(obj.isSelectedOrBorder(userId: userId[i]) == 1)
                if i > 0 {
                    XCTAssert(obj.isSelectedOrBorder(userId: userId[i - 1]) == 0)
                }
            }
            else {
                XCTAssert(obj.isSelectedOrBorder(userId: userId[i]) == 0)
            }
            
            // isSelected
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            if status[i] == .isSelected {
                XCTAssert(obj.isSelected)
            }
            else {
                XCTAssert(!obj.isSelected)
            }
            
            // isIn
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            if status[i] == .isIn {
                XCTAssert(obj.isIn)
            }
            else {
                XCTAssert(!obj.isIn)
            }

            // isOut
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            if status[i] == .isOut {
                XCTAssert(obj.isOut)
            }
            else {
                XCTAssert(!obj.isOut)
            }
            
            // getImageName
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            XCTAssert(obj.getImageName(design: CloseItDesign(data: dataDeaign)) == imageName[i])
            
            // str
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            XCTAssert(obj.str() == str[i])
            
            // data
            obj = CloseItObject(x: x[i], y: y[i], type: type[i], status: status[i])
            // print(obj.data())
            // print(data[i])
            XCTAssert(obj.data() == data[i])
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
