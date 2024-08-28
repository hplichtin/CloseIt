//
//  CloseItChallenge.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 20.12.21.
//

import Foundation

class CloseItChallenge: ObservableObject {
    var data: CloseItDataChallenge
    var dataBoard: CloseItDataBoard
    
    init (data: CloseItDataChallenge, dataBoard: CloseItDataBoard) {
        self.data = data
        self.dataBoard = dataBoard
    }
}
