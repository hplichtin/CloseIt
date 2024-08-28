//
//  CloseItGameScoreListView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 21.09.21.
//

import SwiftUI

struct CloseItGameScoreListView: View {
    @EnvironmentObject var control: CloseItControl
    @ObservedObject var game: CloseItGame
    
    var body: some View {
        if game.myScore != nil {
            CloseItGameScoreRowView(score: game.myScore!, isFinished: $game.isFinished)
        }
        if game.otherScore != nil {
            CloseItGameScoreRowView(score: game.otherScore!, isFinished: $game.isFinished)
        }
    }
}
