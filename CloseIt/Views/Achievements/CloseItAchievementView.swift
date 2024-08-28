//
//  CloseItDataUserView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.12.21.
//

import SwiftUI

struct CloseItAchievementGroupView: View {
    var name: String
    var group: CloseItAchievementGroup
    
    var body: some View {
        let nameText:LocalizedStringKey = LocalizedStringKey(name)
        let completedText:LocalizedStringKey = "completed"
        let ofText:LocalizedStringKey = "of"
        
        Text(nameText).bold()
        Divider()
        Text(completedText)
        Text("\(group.numCompleted)")
        Divider()
        Text(ofText)
        Text("\(group.num)")
    }
}

struct CloseItAchievementGamesView: View {
    var name: String
    var games: CloseItAchievementGames
    
    var body: some View {
        let nameText:LocalizedStringKey = LocalizedStringKey(name)
        let completedText:LocalizedStringKey = "completed"
        let ofText:LocalizedStringKey = "of"
        let playedText:LocalizedStringKey = "played"
        
        Text(nameText).bold()
        Divider()
        Text(completedText)
        Text("\(games.numCompleted)")
        Divider()
        Text(ofText).bold()
        Text("\(games.numPlayed)")
        Text(playedText)
        Divider()
        Text(CloseIt.timeIntervalAsString(timeInterval: games.timePlayed))
    }
}

struct CloseItAchievementGamesDataView: View {
    var name: String
    var games: CloseItAchievementGames
    
    var body: some View {
        let undosText:LocalizedStringKey = LocalizedStringKey(name + " Undos")
        let redosText:LocalizedStringKey = LocalizedStringKey(name + " Redos")
        let restartsText:LocalizedStringKey = LocalizedStringKey(name + " Restarts")
        
        Text(restartsText).bold()
        Text("\(games.numRestarts)")
        Divider()
        Text(undosText).bold()
        Text("\(games.numUndos)")
        Divider()
        Text(redosText).bold()
        Text("\(games.numRedos)")
    }
}

struct CloseItAchievementsView: View {
    var name: String
    var group: CloseItAchievementGroup
    var objects: CloseItAchievementGroup
    var games: CloseItAchievementGames
    
    var body: some View {
        HStack {
            CloseItAchievementGroupView(name: name + " Groups", group: group)
        }
        HStack {
            CloseItAchievementGroupView(name: name, group: objects)
        }
        HStack {
            CloseItAchievementGamesView(name: name + " Games", games: games)
        }
        HStack {
            CloseItAchievementGamesDataView(name: name, games: games)
        }
    }
}


