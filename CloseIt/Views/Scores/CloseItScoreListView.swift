//
//  CloseItScoreListView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 14.12.21.
//

import SwiftUI

struct CloseItScoreRowView: View {
    @EnvironmentObject var control: CloseItControl
    var game: CloseItGame
    @ObservedObject var score: CloseItScore
    @State var isCurrent: Bool
    @State var shapeSize: Bool = false
    
    var design: CloseItDesign {
        let design = control.getDesign(designId: control.resources.dataControl.designId)
        
        return design
    }
    
    var relativeDateAsSring: String {
        return CloseIt.relativeDateAsSring(date: score.startTimestamp)
    }
    
    var body: some View {
        NavigationLink(destination: CloseItGameView(control: control, design: design, game: game, controlZoom: $control.applicationZoom, shapeSize: $shapeSize, controlDebug: $control.applicationDebug, enable: true, showHelpAlways: false), isActive: $isCurrent) {
            CloseItScoreListRowView(groupRank: score.groupRank, scoreRank: score.scoreRank, userId: score.userId, text: relativeDateAsSring)
        }
    }
}

struct CloseItScoreListView: View {
    @EnvironmentObject var control: CloseItControl
    @State var isCollapsed: Bool
    var scores: [CloseItScore]
    @ObservedObject var user: CloseItUser
    
    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text("\(scores[0].groupRank).")
            Text("Score: \(scores[0].scoreId)").bold()
        }
        if !isCollapsed {
            let appGame = control.applicationCurrentScore!.game!
            
            ForEach(scores) { s in
                if control.applicationShowAll || appGame.id == s.gameId /* && s.hasData(boardId: s.boardId, userId: control.resources.dataControl.showCurrentUserOnly ? user.id : nil, includeChallenges: control.resources.dataControl.showChallengeScores)*/ {
                    CloseItScoreRowView(game: s.game!, score: s, isCurrent: appGame.id == s.gameId)
                }
            }
        }
    }
}
