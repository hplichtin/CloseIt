//
//  CloseItDataBoardView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 23.11.21.
//

import SwiftUI

struct CloseItDataBoardRowView: View {
    @EnvironmentObject var control: CloseItControl
    @ObservedObject var gData: CloseItGames.Data
    
    var body: some View {
        let boardNameText:LocalizedStringKey = LocalizedStringKey(gData.game.board.boardName)
        
        Text(boardNameText)
        Divider()
        if gData.achievedScores.numCompleted > 0 {
            Image(systemName: CloseItControl.UserInterface.challengeSystemImageName)
            if gData.achievedScores.numCompleted > 1 {
                Text("x\(gData.achievedScores.numCompleted)")
                Divider()
            }
        }
        else {
            Image(systemName: CloseItControl.UserInterface.challengeOpenSystemImageName)
        }
        if gData.game.board.challenge != "" {
            Text(gData.game.board.challenge)
        }
    }
}
