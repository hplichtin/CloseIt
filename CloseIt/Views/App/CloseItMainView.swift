//
//  CloseItMainView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import SwiftUI

struct CloseItMainView: View {
    @Binding var admin: Bool
    @Binding var applicationView: CloseItControl.ApplicationView
    @Binding var applicationCurrentUser: CloseItUser?
    @Binding var publishedScoreChallenges: String
    @Binding var publishedScoreBoards: String
    var challengeGames: CloseItGamesGroup
    var boardGames: CloseItGamesGroup
    var users: CloseItUsers

    
    var body: some View {
        let infoText:LocalizedStringKey = "Info"
        let boardsText:LocalizedStringKey = "Boards"
        let challengesText:LocalizedStringKey = "Challenges"
        let usersText:LocalizedStringKey = "Users"
        let adminText:LocalizedStringKey = "Admin"

        TabView(selection: $applicationView) {
            CloseItInfoView(title: infoText)
                .tabItem {
                    Label(infoText, systemImage: CloseItControl.UserInterface.startSystemImageName)
                }
                .tag(CloseItControl.ApplicationView.infoApplicationView)
            CloseItGamesGroupView(title: challengesText, group: challengeGames, score: $publishedScoreChallenges)
                .tabItem {
                    Label(challengesText, systemImage: CloseItControl.UserInterface.challengeSystemImageName)
                }
                .tag(CloseItControl.ApplicationView.challengesApplicationView)
            CloseItGamesGroupView(title: boardsText, group: boardGames, score: $publishedScoreBoards)
                .tabItem {
                    Label(boardsText, systemImage: CloseItControl.UserInterface.boardSystemImageName)
                }
                .tag(CloseItControl.ApplicationView.boardsApplicationView)
            CloseItUserListView(title: usersText, users: users)
                .tabItem {
                    Label(usersText, systemImage: CloseItControl.UserInterface.usersSystemImageName)
                }
                .tag(CloseItControl.ApplicationView.usersApplicationView)
            if admin {
                CloseItAdminView()
                    .tabItem {
                        Label(adminText, systemImage: CloseItControl.UserInterface.adminSystemImageName)
                    }
                    .tag(CloseItControl.ApplicationView.adminApplicationView)
            }
        }
    }
}
