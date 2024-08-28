//
//  CloseItApp.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import SwiftUI

@main
struct CloseItApp: App {
    @StateObject private var control = CloseItControl()
    
    var body: some Scene {
        WindowGroup {
            if control.applicationInit {
                if control.isMainApplicationView(applicationView: control.applicationView) {
                    CloseItMainView(admin: $control.applicationAdmin, applicationView: $control.applicationView, applicationCurrentUser: $control.applicationCurrentUser, publishedScoreChallenges: $control.publishedScoreChallenges, publishedScoreBoards: $control.publishedScoreBoards, challengeGames: control.resources.challengeGames, boardGames: control.resources.boardGames, users: control.resources.users)
                        .environmentObject(control)
                }
                else if control.applicationView == .scoreApplicationView {
                    CloseItBoardScoresListView(boardScores: control.resources.boardScores, user: control.applicationCurrentUser!)
                        .environmentObject(control)
                }
                else if control.applicationView == .achievementApplicationView {
                    CloseItAchievementApplicationView()
                        .environmentObject(control)
                }
            }
        }
    }
    
    func applicationWillResignActive (_ application: UIApplication) {
        CLOSEIT_FUNC_START()
        control.storeControlDataApplicationView(applicationView: control.applicationView)
        CLOSEIT_FUNC_END()
    }

}
