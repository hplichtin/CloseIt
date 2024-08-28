//
//  CloseItScoreView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 21.09.21.
//

import SwiftUI

struct CloseItScoreView: View {
    @EnvironmentObject var control: CloseItControl
    var game: CloseItGame
    @ObservedObject var score: CloseItScore
    @State var isCollapsed: Bool = true
    @State var shapeSize: Bool = false
    
    var design: CloseItDesign {
        let design = control.getDesign(designId: control.resources.dataControl.designId)
        
        return design
    }
    
    var body: some View {
        let scoreText:LocalizedStringKey = "Score"
        let cellsText:LocalizedStringKey = "Cells"
        
        List {
            HStack {
                Text("Board").bold()
                Divider()
                Text(control.getBoardName(boardId: score.boardId)).bold()
            }
            HStack {
                let groupRank = control.resources.boardScores.getGroupRank(score: score)
                
                Text("Rank").bold()
                Divider()
                Text((groupRank != 0 ? "\(groupRank)" : "-") + "." + (score.scoreRank != 0 ? "\(score.scoreRank)" : "-") + ".")
                Divider()
                Text("User").bold()
                Divider()
                Image(systemName: CloseItControl.getCurrentUserImageName(isCurrent: score.userId == control.applicationCurrentUser!.id))
                Text(control.resources.users.find(userId: score.userId).data.name)
            }
            HStack {
                Text(scoreText).bold()
                Divider()
                Text(score.scoreId)
                Text("(a)x(b)x(c)x(d)").foregroundColor(Color.gray)
                Divider()
                Image(systemName: CloseItControl.getChallengeImageName(isCompleted: score.completed))
            }
            HStack {
                Text(cellsText).bold()
                Divider()
                Text("\(score.numSelectedCells)")
                Text("(a)").foregroundColor(Color.gray)
                Divider()
                Text("of").bold()
                Divider()
                Text("\(score.numSelectableCells)")
            }
            HStack {
                Text("Streak").bold()
                Divider()
                Text("\(score.maxStreakCount)")
                Text("(b)").foregroundColor(Color.gray)
            }
            HStack {
                Text("Lines").bold()
                Divider()
                VStack(alignment: .leading) {
                    HStack {
                        Text("X:").bold()
                        Text("\(score.numSelectedLinesX)")
                        Text("+").bold()
                        Text("Y:").bold()
                        Text("\(score.numSelectedLinesY)")
                        Text("=").bold()
                        Text("\(score.numSelectedLines)")
                        Text("(c)").foregroundColor(Color.gray)
                    }
                    HStack {
                        Text("min:").bold()
                        Text("\(score.minNumSelectedLinesXY)")
                        Text("(d)").foregroundColor(Color.gray)
                    }
                }
            }
            if score.isChallenge {
                HStack {
                    Text("Challenge").bold()
                    Divider()
                    if score.completed {
                        Image(systemName: CloseItControl.UserInterface.challengeSystemImageName)
                    }
                    else {
                        Image(systemName: CloseItControl.UserInterface.challengeOpenSystemImageName)
                    }
                    Text(score.challenge)
                }
            }
            HStack {
                Text("Timestamps").bold()
                Divider()
                Text(score.startTimestamp.description)
                Text("-").bold()
                Text(score.endTimestamp.description)
                Text("=>").bold()
                Text(score.timePlayedAsStr)
            }
            HStack {
                CloseItExpandButtonView(isSet: $isCollapsed)
                Text("Ids").bold()
                Divider()
                if !isCollapsed {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Board Id:").bold()
                            Divider()
                            Text(score.boardId)
                        }
                        Divider()
                        HStack {
                            Text("User Id:").bold()
                            Divider()
                            Text(score.userId.description)
                        }
                        Divider()
                        HStack {
                            Text("Game Id:").bold()
                            Divider()
                            Text(score.gameId.description)
                        }
                        Divider()
                        HStack {
                            Text("Score Id:").bold()
                            Divider()
                            Text(score.id.description)
                        }
                    }
                }
            }
            CloseItGameView(control: control, design: design, game: game, controlZoom: $control.applicationZoom, shapeSize: $shapeSize, controlDebug: $control.applicationDebug, enable: true, showHelpAlways: false)
        }
    }
}
