//
//  CloseItBoard.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import Foundation

class CloseItBoard: CloseItClass, ObservableObject {
    var boardGroup, boardId: String
    var cells, linesX, linesY: CloseItObjectTable

    @Published var size: Int
    var target: String
    @Published var challenge: String

    var level: Level
    var availableAfterDays: Int

    init (data: CloseItDataBoard, challenge: String, level: Level, availableAfterDays: Int) {
        boardGroup = data.group
        boardId = data.id
        cells = CloseItObjectTable(sizeX: data.sizeX, sizeY: data.sizeY, type: .isCell, statusStr: data.cells)
        linesX = CloseItObjectTable(sizeX: data.sizeX, sizeY: data.sizeY + 1, type: .isLineX, status: .isIn)
        linesY = CloseItObjectTable(sizeX: data.sizeX + 1, sizeY: data.sizeY, type: .isLineY, status: .isIn)
        size = data.sizeX * data.sizeY
        self.target = data.target
        self.challenge = challenge
        self.level = level
        self.availableAfterDays = availableAfterDays
        super.init()
        resetBorderLines()
    }
    
    init (board: CloseItBoard) {
        boardGroup = board.boardGroup
        boardId = board.boardId
        cells = CloseItObjectTable(table: board.cells)
        linesX = CloseItObjectTable(table: board.linesX)
        linesY = CloseItObjectTable(table: board.linesY)
        size = board.size
        target = board.target
        challenge = board.challenge
        level = board.level
        availableAfterDays = board.availableAfterDays
    }
    
    func copy (board: CloseItBoard) {
        boardGroup = board.boardGroup
        boardId = board.boardId
        cells.copy(table: board.cells)
        linesX.copy(table: board.linesX)
        linesY.copy(table: board.linesY)
        target = board.target
        size = board.size
        challenge = board.challenge
        availableAfterDays = board.availableAfterDays
    }
    
    override func helpType () -> String {
        return CloseItDataBoard.type
    }
    
    override func helpId () -> String {
        var id = boardId
        
        if isChallenge {
            id += separator + challenge
        }
        return id
    }
    
    static func getGroupName (group: String) -> String {
        let name = CloseIt.getLocalizedText(type: "groupName", id: group)
        
        return name
    }
    
    var groupName: String {
        let name = CloseItBoard.getGroupName(group: boardGroup)
        
        return name
    }
    
    static func getBoardName (boardId: String) -> String {
        let boardName = CloseIt.getLocalizedText(type: "boardName", id: boardId)
        
        return boardName
    }
    
    var boardName: String {
        return CloseItBoard.getBoardName(boardId: boardId)
    }
    
    func getDataBoard () -> CloseItDataBoard {
        return CloseItDataBoard(group: boardGroup, id: boardId, sizeX: sizeX, sizeY: sizeY, cells: "")
    }
    
    var sizeX: Int { return cells.count }
    var sizeY: Int { return ( sizeX == 0 ? 0 : cells[0].count ) }
    
    var isChallenge: Bool {
        return challenge != ""
    }
    
    var isBoard: Bool {
        return challenge == ""
    }
    
    private func setObjectSelectable (_ obj: CloseItObject) {
        var isSelectable: Bool
        
        if obj.isLine {
            isSelectable = true
            if obj.isLineX {
                if !obj.isIn && !obj.isSelected {
                    isSelectable = false
                }
                if obj.y > 0 {
                    if cells[obj.x][obj.y - 1].isSelected {
                        isSelectable = false
                    }
                }
                if obj.y < sizeY {
                    if cells[obj.x][obj.y].isSelected {
                        isSelectable = false
                    }
                }
                linesX[obj.x][obj.y].isSelectable = isSelectable
            }
            else if obj.isLineY {
                if !obj.isIn && !obj.isSelected {
                    isSelectable = false
                }
                if obj.x > 0 {
                    if cells[obj.x - 1][obj.y].isSelected {
                        isSelectable = false
                    }
                }
                if obj.x < sizeX {
                    if cells[obj.x][obj.y].isSelected {
                        isSelectable = false
                    }
                }
                linesY[obj.x][obj.y].isSelectable = isSelectable
            }
            else {
                abort()
            }
        }
        else if obj.isCell {
            let x = obj.x
            let y = obj.y

            isSelectable = false
            if !obj.isSelected {
                let max = maxCellCloseItCount()
                let c = getCellLinesSelectedOrBorderCount(x: x, y: y)

                if c >= max - 1 {
                    isSelectable = true
                }
                else if c == max - 2 {
                    if x > 0 {
                        // left
                        if cells[x - 1][y].isSelected && linesY[x][y].isSelectedOrBorder == 0 {
                            isSelectable = true
                        }
                    }
                    if x < sizeX - 1 {
                        // right
                        if cells[x + 1][y].isSelected && linesY[x + 1][y].isSelectedOrBorder == 0 {
                            isSelectable = true
                        }
                    }
                    if y > 0 {
                        // below
                        if cells[x][y - 1].isSelected && linesX[x][y].isSelectedOrBorder == 0 {
                            isSelectable = true
                        }
                    }
                    if y < sizeY - 1 {
                        // above
                        if cells[x][y + 1].isSelected && linesX[x][y + 1].isSelectedOrBorder == 0 {
                            isSelectable = true
                        }
                    }
                }
            }
            cells[x][y].isSelectable = isSelectable
        }
        else {
            abort()
        }
    }
    
    private func resetBorderLines () {
        var x, y: Int
        
        // set first and last X
        x = 0
        while x < sizeX {
            linesX[x][0].set(status: (cells[x][0].isIn || cells[x][0].isSelected ? .isBorder : .isOut))
            linesX[x][sizeY].set(status: (cells[x][sizeY - 1].isIn || cells[x][sizeY - 1].isSelected ? .isBorder : .isOut))
            x += 1
        }
        // set first and last Y
        y = 0
        while y < sizeY {
            linesY[0][y].set(status: (cells[0][y].isIn || cells[0][y].isSelected ? .isBorder : .isOut))
            linesY[sizeX][y].set(status: (cells[sizeX - 1][y].isIn || cells[sizeX - 1][y].isSelected ? .isBorder : .isOut))
            y += 1
        }
        // set inside line X and line Y
        x = 0
        while x < sizeX {
            y = 0
            while y < sizeY {
                if cells[x][y].isSelected {
                    if y > 0 {
                        linesX[x][y].set(status: (cells[x][y - 1].isOut ? .isBorder : .isSelected))
                        linesX[x][y].isSelectable = false
                    }
                    if y < sizeY - 1 {
                        linesX[x][y + 1].set(status: (cells[x][y + 1].isOut ? .isBorder : .isSelected))
                        linesX[x][y + 1].isSelectable = false
                    }
                    if x > 0 {
                        linesY[x][y].set(status: (cells[x - 1][y].isOut ? .isBorder : .isSelected))
                        linesY[x][y].isSelectable = false
                   }
                    if x < sizeX - 1 {
                        linesY[x + 1][y].set(status: (cells[x + 1][y].isOut ? .isBorder : .isSelected))
                        linesY[x + 1][y].isSelectable = false

                    }
                }
                else if cells[x][y].isOut {
                    if y > 0 {
                        linesX[x][y].set(status: (cells[x][y - 1].isOut ? .isOut : .isBorder))
                    }
                    if y < sizeY - 1 {
                        linesX[x][y + 1].set(status: (cells[x][y + 1].isOut ? .isOut : .isBorder))
                    }
                    if x > 0 {
                        linesY[x][y].set(status: (cells[x - 1][y].isOut ? .isOut : .isBorder))
                    }
                    if x < sizeX - 1 {
                        linesY[x + 1][y].set(status: (cells[x + 1][y].isOut ? .isOut : .isBorder))
                    }
                }
                y += 1
            }
            x += 1
        }
        //
        // set cells isSelectable
        //
        for line in cells {
            for cell in line {
                setObjectSelectable(cell)
            }
        }
    }

    func reset () {
        cells.reset()
        linesX.reset()
        linesY.reset()
        resetBorderLines()
    }
    
    func numCells () -> Int {
        size = sizeX * sizeY
        return size
    }
    
    func numSelectableCells () -> Int {
        var s = 0
        
        for cs in cells {
            for c in cs {
                if c.isIn || c.isSelected {
                    s += 1
                }
            }
        }
        return s
    }
    
    func areAllCellsSelected () -> Bool {
        return cells.areAllCellsSelected()
    }
    
    func getCellLinesSelectedOrBorderCount (x: Int, y: Int) -> Int {
        var c = 0
        
        c += linesX[x][y].isSelectedOrBorder
        c += linesX[x][y + 1].isSelectedOrBorder
        c += linesY[x][y].isSelectedOrBorder
        c += linesY[x + 1][y].isSelectedOrBorder
        return c
    }
    
    private func setSelectableNextToObject (obj: CloseItObject) {
        let x = obj.x
        let y = obj.y
        
        switch obj.type {
        case .isLineX:
            // cell above
            setObjectSelectable(cells[x][y])
            // cell below
            setObjectSelectable(cells[x][y - 1])
        case .isLineY:
            // cell right
            setObjectSelectable(cells[x][y])
            // cell left
            setObjectSelectable(cells[x - 1][y])
        case .isCell:
            // lineX above
            setObjectSelectable(linesX[x][y + 1])
            // lineX below
            setObjectSelectable(linesX[x][y])
            // lineY right
            setObjectSelectable(linesY[x + 1][y])
            // lineY left
            setObjectSelectable(linesY[x][y])
            // cell above
            if y < sizeY - 1 {
                setObjectSelectable(cells[x][y + 1])
            }
            // cell below
            if y > 0 {
                setObjectSelectable(cells[x][y - 1])
            }
            // cell right
            if x < sizeX - 1 {
                setObjectSelectable(cells[x + 1][y])
            }
            // cell left
            if x > 0 {
                setObjectSelectable(cells[x - 1][y])
            }
        }
    }
    
    func setObject (obj: CloseItObject, status: CloseItObject.Status, userId: String? = nil) {
        obj.set(status: status, userId: userId)
        setObjectSelectable(obj)
        setSelectableNextToObject(obj: obj)
    }
    
/*    func getLineCellsSelected (line: CloseItObject) -> Int {
        var c = 0
        
        if line.isLineX {
            if line.y > 0 {
                if cells[line.x][line.y - 1].isSelected {
                    c += 1
                }
            }
            if cells[line.x][line.y].isSelected {
                c += 1
            }
        }
        else if line.isLineY {
            if line.x > 0 {
                if cells[line.x - 1][line.y].isSelected {
                    c += 1
                }
            }
            if cells[line.x][line.y].isSelected {
                c += 1
            }
        }
        return c
    }
 */

    func maxCellCloseItCount () -> Int {
        return 4
    }
    
    func getBoardLine (type: CloseItObject.Object, y: Int) -> CloseItObjectArray {
        let objs = CloseItObjectArray()
        var x = 0
        
        while x < sizeX {
            if type == .isLineX {
                objs.append(obj: linesX[x][y])
            }
            if type == .isLineY || type == .isCell {
                objs.append(obj: linesY[x][y])
                objs.append(obj: cells[x][y])
            }
            x += 1
        }
        if type == .isLineY || type == .isCell {
            objs.append(obj: linesY[x][y])
        }
        return objs
    }
    
    func getBoardView () -> CloseItObjectTable {
        let objs = CloseItObjectTable()
        var y = sizeY
        
        objs.append(array: getBoardLine(type: .isLineX, y: y))
        y -= 1
        while y >= 0 {
            objs.append(array: getBoardLine(type: .isCell, y: y))
            objs.append(array: getBoardLine(type: .isLineX, y: y))
            y -= 1
        }
        return objs
    }
    
    func getNumSelectedLinesXNotAtSelectedCells () -> Int {
        var n: Int = 0
        var x: Int = 0
        
        while x < sizeX {
            var y: Int = 1
            while y < sizeY {
                if linesX[x][y].isSelected && !cells[x][y - 1].isSelected && !cells[x][y].isSelected {
                    n += 1
                }
                y += 1
            }
            x += 1
        }
        return n
    }
    
    func getNumSelectedLinesYNotAtSelectedCells () -> Int {
        var n: Int = 0
        var x: Int = 1
        
        while x < sizeX {
            var y: Int = 0
            while y < sizeY {
                if linesY[x][y].isSelected && !cells[x - 1][y].isSelected && !cells[x][y].isSelected {
                    n += 1
                }
                y += 1
            }
            x += 1
        }
        return n
    }
    
    func cellsBoardData () -> String {
        var s = ""
        var x = 0
        
        while x < sizeX {
            var y = 0
            
            while y < sizeY {
                if cells[x][y].isOut {
                    s += String(CloseItObject.value(status: .isOut))
                }
                else {
                    s += String(CloseItObject.value(status: .isIn))
                }
                y += 1
            }
            x += 1
        }
        return s
    }
    
    func str() -> String {
        var str = ""
        str += "[C:" + cells.str() + "]"
        str += "[X:" + linesX.str() + "]"
        str += "[Y:" + linesY.str() + "]"
        return str
    }
    
    func asTable() -> String {
        var str = ""
        var y = sizeY
        while y >= 0 {
            var x = 0
            while x < sizeX {
                str += " " + linesX[x][y].str()
                x += 1
            }
            str += "\n"
            x = 0
            y -= 1
            while x < sizeX && y >= 0 {
                str += linesY[x][y].str()
                str += cells[x][y].str()
                x += 1
            }
            if y >= 0 {
                str += linesY[x][y].str()
            }
            str += "\n"
        }
        return str
    }
}

