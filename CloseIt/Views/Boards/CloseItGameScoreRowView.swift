//
//  CloseItGameScoreRowView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 21.09.21.
//

import SwiftUI

struct CloseItGameScoreIdView: View {
    static let textC:LocalizedStringKey = "[KEY|scoreId|numSelectedCells]"
    static let textS:LocalizedStringKey = "[KEY|scoreId|maxStreakCount]"
    static let textL:LocalizedStringKey = "[KEY|scoreId|numSelectedLines]"
    static let textXY:LocalizedStringKey = "[KEY|scoreId|minNumSelectedLinesXY]"

    var scoreShort: String
    var scoreData: CloseItDataScore.Score
    
    func idString (_ num: Int) -> String {
        return num == CloseItDataScore.scoreAllNum ? CloseItDataScore.scoreAll : num.description
    }

    var body: some View {
        if CloseIt.isPhone {
            Text(scoreShort)
        }
        else {
            Text(CloseItGameScoreIdView.textC).foregroundColor(Color.gray)
            Text(idString(scoreData.numSelectedCells)).bold()
            Text("|")
            Text(CloseItGameScoreIdView.textS).foregroundColor(Color.gray)
            Text(idString(scoreData.maxStreakCount)).bold()
            Text("|")
            Text(CloseItGameScoreIdView.textL).foregroundColor(Color.gray)
            Text(idString(scoreData.numSelectedLines)).bold()
            Text("|")
            Text(CloseItGameScoreIdView.textXY).foregroundColor(Color.gray)
            Text(idString(scoreData.minNumSelectedLinesXY)).bold()
        }
    }
}

struct CloseItGameScoreRowView: View {
    @EnvironmentObject var control: CloseItControl
    @ObservedObject var score: CloseItScore
    @Binding var isFinished: Bool
    @State var isCollapsed = true
    
    func getUser() -> CloseItUser {
        return control.applicationCurrentUser!
    }
    
    var numScores: Int {
        let a = control.resources.boardScores.getAchievement(score: score, level: control.applicationLevel)
        return a.numCompleted
    }
    
    var body: some View {
        let scoreText:LocalizedStringKey = "Score"
        let cellsText:LocalizedStringKey = "Cells"
        let streakText:LocalizedStringKey = "Streak"
        let maxText:LocalizedStringKey = "max"
        let currentText:LocalizedStringKey = "current"
        let linesText:LocalizedStringKey = "Lines"
        let sumText:LocalizedStringKey = "sum"
        let minText:LocalizedStringKey = "min"
        let restartsText:LocalizedStringKey = "Restarts"
        let undosText:LocalizedStringKey = "Undos"
        let redosText:LocalizedStringKey = "Redos"
        let startText:LocalizedStringKey = "Start"
        let playedText:LocalizedStringKey = "Played"
        
        HStack {
            let user = getUser()
            
            CloseItExpandButtonView(isSet: $isCollapsed)
            Image(systemName: CloseItControl.getCurrentUserImageName(isCurrent: user.id == score.userId))
            Text(user.data.name).bold()
            Divider()
            if isCollapsed {
                CloseItGameScoreIdView(scoreShort: score.data.currentScoreStr, scoreData: score.data.currentScoreData)
                Divider()
            }
            
            // let fontStyle: Font.TextStyle = CloseIt.isPhone ? .system(size: 8) : nil
            
            VStack(alignment: .leading) {
                if !isCollapsed {
                    HStack {
                        Text(scoreText).bold()
                        Divider()
                        CloseItGameScoreIdView(scoreShort: score.data.currentScoreStr, scoreData: score.data.currentScoreData)
                    }
                    Divider()
                    HStack {
                        Text(cellsText).bold()
                        Divider()
                        Text(CloseItGameScoreIdView.textC).foregroundColor(Color.gray)
                        Text("\(score.numSelectedCells)").bold()
                        Divider()
                        Text("of").bold()
                        Divider()
                        Text("\(score.numSelectableCells)")
                    }
                    Divider()
                    HStack {
                        Text(streakText).bold()
                        Divider()
                        Text(maxText).bold()
                        Divider()
                        Text(CloseItGameScoreIdView.textS).foregroundColor(Color.gray)
                        Text("\(score.maxStreakCount)").bold()
                        Divider()
                        Text(currentText).bold()
                        Divider()
                        Text("\(score.currentStreakCount)")
                    }
                    Divider()
                    HStack {
                        Text(linesText).bold()
                        Divider()
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                Text(sumText).bold()
                                Divider()
                                Text("X").bold()
                                Divider()
                                Text("\(score.numSelectedLinesX)")
                                Text("+").bold()
                                Text("Y").bold()
                                Text("\(score.numSelectedLinesY)")
                                Text("=").bold()
                                Text(CloseItGameScoreIdView.textL).foregroundColor(Color.gray)
                                Text("\(score.numSelectedLines)").bold()
                            }
                            Divider()
                            HStack {
                                Text(minText).bold()
                                Text(CloseItGameScoreIdView.textXY).foregroundColor(Color.gray)
                                Text("\(score.minNumSelectedLinesXY)").bold()
                            }
                        }
                    }
                    Divider()
                    CloseItValueView(text: restartsText, value: score.data.numRestarts)
                    Divider()
                    CloseItValueView(text: undosText, value: score.data.numUndos)
                    Divider()
                    CloseItValueView(text: redosText, value: score.data.numRedos)    
                    Divider()
                    if !isFinished {
                        if score.hasScore() {
                            CloseItDateView(text: startText, value: score.data.startTimestamp)
                        }
                        else {
                            HStack {
                                Text(startText).bold()
                                Divider()
                                Text("-")
                            }
                        }
                    }
                    else {
                        CloseItTimelineView(text: playedText, from: score.data.startTimestamp, to: score.data.endTimestamp)
                    }
                }
            }
            .font(CloseIt.isPhone ? .system(size: 10) : nil)
            Divider()
            Image(systemName: CloseItControl.getChallengeImageName(isCompleted: score.completed))
            if score.challenge != "" {
                CloseItGameScoreIdView(scoreShort: score.challenge, scoreData: score.data.challengeScore)
                // Text("\(score.challenge)")
            }
            else if score.data.target != "" {
                CloseItGameScoreIdView(scoreShort: score.data.target, scoreData: score.data.targetScore)
                // Text("\(score.data.target)")
            }
            if isFinished {
                let rankText:LocalizedStringKey = "Rank"
                let timeText:LocalizedStringKey = "Time"
                let newText:LocalizedStringKey = "New Score"
                
                Divider()
                if score.challenge == "" {
                    if numScores == 1 {
                        Text(newText)
                    }
                    Divider()
                }
                Text(rankText)
                Text("\(score.groupRank).\(score.scoreRank)")
                Divider()
                Text(timeText)
                Text(score.timePlayedAsStr)
            }
        }
    }
}
