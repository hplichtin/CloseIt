//
//  CloseItBoardScoresListView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 25.12.21.
//

import SwiftUI

struct CloseItBoardScoresView: View {
    @EnvironmentObject var control: CloseItControl
    var bsData: CloseItBoardScores.Data
    var appUserId: String
    @ObservedObject var user: CloseItUser
    
    var body: some View {
        //let numScores = CloseItScore.getAchievement(scores: bsData.scores, game: control.applicationCurrentScore!.game!, userId: appUserId, level: control.applicationLevel)
            
        if /* numScores.numPlayed > 0 && */ (control.applicationShowAll || bsData.scoreId == control.applicationCurrentScore!.scoreId) {
            CloseItScoreListView(isCollapsed: bsData.isScoresCollapsed, scores: bsData.scores, user: user)
        }
    }
}

struct CloseItBoardScoresListView: View {
    @EnvironmentObject var control: CloseItControl
    var boardScores: CloseItBoardScores
    @ObservedObject var user: CloseItUser
    
    var body: some View {
        let gamesText:LocalizedStringKey = "Games"
        let boardText:LocalizedStringKey = "Board"
        
        NavigationView {
            List {
                if control.applicationView == .scoreApplicationView && control.applicationCurrentScore != nil {
                    let appUserId = user.id
                    let boardName = control.applicationCurrentScore!.boardName
 
                    HStack {
                        Text(boardText).font(.title2).bold()
                        Divider()
                        Text(boardName).font(.title2)
                    }
                    ForEach(boardScores.data.filter { $0.boardName == boardName }) { bs in
                        CloseItBoardScoresView(bsData: bs, appUserId: appUserId, user: user)
                    }
                }
                if control.applicationDebug {
                    CloseItDebugTextView()
                    Text("control.applicationShowAll: \(control.applicationShowAll)")
                }
            }
            .navigationTitle(gamesText)
            .toolbar {
                HStack {
                    Button(action: {
                        control.closeScoreApplicationView()
                    }) {
                        Image(systemName: CloseItControl.UserInterface.closeSystemImageName)
                    }
                    Divider()
                    if control.applicationCurrentScore!.game!.isFinished {
                        Button(action: {
                            control.toggleShowAll()
                        }) {
                            Image(systemName: CloseItControl.getShowAllImageName(showAll: control.applicationShowAll))
                        }
                    }
                }
            }
        }
    }
}
