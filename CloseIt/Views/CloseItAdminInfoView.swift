//
//  CloseItInfoView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 18.09.22.
//

import SwiftUI

struct CloseItInfoConfigView: View {
    var config: CloseItDataConfig
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true
    
    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text("Config").font(.title2).bold()
        }
        if !isCollapsed {
            Text(config.value(showName: showNames))
        }
    }
}

struct CloseItInfoFeaturesView: View {
    @EnvironmentObject var control: CloseItControl
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true
    
    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text("Features").font(.title2).bold()
            Divider()
            Text("\(control.resources.features.count)")
        }
        if !isCollapsed {
            ForEach(control.resources.features) { feature in
                Text(feature.value(showName: showNames))
            }
        }
    }
}

struct CloseItInfoIncidentsView: View {
    @EnvironmentObject var control: CloseItControl
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true
    
    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text("Incidents").font(.title2).bold()
            Divider()
            Text("\(control.resources.incidents.count)")
        }
        if !isCollapsed {
            ForEach(control.resources.incidents) { incident in
                Text(incident.value(showName: showNames))
            }
        }
    }
}

struct CloseItInfoControlView: View {
    var control: CloseItControl
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true
    
    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text("Control").font(.title2).bold()
        }
        if !isCollapsed {
            Text(control.value(showName: showNames))
        }
    }
}

struct CloseItInfoDesignView: View {
    @EnvironmentObject var control: CloseItControl
    var design: CloseItDesign
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true
    @State var shapeSize: Bool = false
    
    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(design.value(showName: showNames))
        }
        if !isCollapsed {
            CloseItBoardView(control: control, design: design, game: CloseItGame.defaultGame(), resize: false, controlZoom: $control.applicationZoom, shapeSize: $shapeSize, enable: false, showHelpAlways: false, controlDebug: $control.applicationDebug)
        }
    }
}

struct CloseItInfoDesignsView: View {
    @EnvironmentObject var control: CloseItControl
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text("Designs").font(.title2).bold()
            Divider()
            Text("\(control.resources.designs.count)")
        }
        if !isCollapsed {
            ForEach(control.resources.designs) { design in
                CloseItInfoDesignView(design: design, showNames: $showNames)
            }
        }
    }
}

struct CloseItInfoLevelView: View {
    var level: CloseItLevel
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true
    
    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(level.value(showName: showNames))
        }
        if !isCollapsed {
            Image(level.badgeImageName)
                .resizable()
                .frame(width: 100, height: 100)
        }
    }
}

struct CloseItInfoLevelsView: View {
    @EnvironmentObject var control: CloseItControl
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text("Levels").font(.title2).bold()
            Divider()
            Text("\(control.resources.levels.count)")
        }
        if !isCollapsed {
            ForEach(control.resources.levels.levels) { level in
                CloseItInfoLevelView(level: level, showNames: $showNames)
            }
        }
    }
}

struct CloseItInfoUsersView: View {
    @EnvironmentObject var control: CloseItControl
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text("Users").font(.title2).bold()
            Divider()
            Text("\(control.resources.users.count)")
        }
        if !isCollapsed {
            ForEach(control.resources.users) { user in
                Text(user.value(showName: showNames))
            }
        }
    }
}

struct CloseItInfoPlayerView: View {
    @EnvironmentObject var control: CloseItControl
    var player: CloseItPlayer
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true
    
    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text("Player").font(.title2).bold()
        }
        if !isCollapsed {
            Text(player.value(showName: showNames))
        }
    }
}

struct CloseItInfoDemoView: View {
    @EnvironmentObject var control: CloseItControl
    var demo: CloseItDemo
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true

    var body: some View {
        HStack {
//            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(demo.value(showName: showNames))
        }
//        if !isCollapsed {
//        }
    }
}

struct CloseItInfoDemosView: View {
    var title: String
    var demos: CloseItDemos
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(title).font(.title2).bold()
            Divider()
            Text("\(demos.count)")
        }
        if !isCollapsed {
            ForEach(demos.demos) { demo in
                CloseItInfoDemoView(demo: demo, showNames: $showNames)
            }
        }
    }
}

struct CloseItInfoBoardView: View {
    @EnvironmentObject var control: CloseItControl
    var dataBoard: CloseItDataBoard
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true
    @State var shapeSize: Bool = false

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(dataBoard.value(showName: showNames))
        }
        if !isCollapsed {
            CloseItBoardView(control: control, design: control.getDesign(designId: control.resources.dataControl.designId), game: CloseItGame(dataBoard: dataBoard, challenge: "", level: 0, availableAfterDays: 0), resize: false, controlZoom: $control.applicationZoom, shapeSize: $shapeSize, enable: false, showHelpAlways: false, controlDebug: $control.applicationDebug)
        }
    }
}

struct CloseItInfoBoardsView: View {
    var title: String
    var dataBoards: [CloseItDataBoard]
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(title).font(.title2).bold()
            Divider()
            Text("\(dataBoards.count)")
        }
        if !isCollapsed {
            ForEach(dataBoards) { board in
                CloseItInfoBoardView(dataBoard: board, showNames: $showNames)
            }
        }
    }
}

struct CloseItAdminInfoChallengesView: View {
    var title: String
    var dataChallenges: [CloseItDataChallenge]
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(title).font(.title2).bold()
            Divider()
            Text("\(dataChallenges.count)")
        }
        if !isCollapsed {
            ForEach(dataChallenges) { challenge in
                Text(challenge.value(showName: showNames))
            }
        }
    }
}

struct CloseItAdminInfoAchievementsView: View {
    @EnvironmentObject var control: CloseItControl
    var title: String
    var achivements: CloseItAchievements
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(title).font(.title2).bold()
            Divider()
            Text("\(achivements.count)")
        }
        if !isCollapsed {
            ForEach(achivements.objects) { achievement in
                Text(achievement.value(showName: showNames))
            }
        }
    }

}

struct CloseItInfoGamesView: View {
    @EnvironmentObject var control: CloseItControl
    var title: String
    var games: CloseItGames
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(title).font(.title2).bold()
            Divider()
            Text("\(control.resources.doneGames.count)")
        }
        if !isCollapsed {
            ForEach(games.data) { dg in
                Text(dg.game.data().value(showName: showNames))
            }
        }
    }
}

struct CloseItInfoScoresView: View {
    @EnvironmentObject var control: CloseItControl
    @Binding var showNames: Bool
    @State var isCollapsed: Bool = true

    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text("Scores").font(.title2).bold()
             Divider()
            Text("\(control.resources.boardScores.count)")
        }
        if !isCollapsed {
             ForEach(control.resources.boardScores.data) { boardScore in
                 ForEach(boardScore.scores) { score in
                     HStack {
                         Text("\(score.groupRank).\(score.scoreRank).")
                         Divider()
                         Text(score.value(showName: showNames))
                     }
                 }
             }
         }
    }
}

struct CloseItInfoVarView: View {
    @EnvironmentObject var control: CloseItControl

    var body: some View {
        HStack {
            Text(CloseIt.program).bold()
            Divider()
            Text(CloseIt.version).bold()
            Divider()
            Text(CloseIt.build).bold()
        }
        HStack {
            Text(CloseIt.designer).bold()
            Divider()
            Text(CloseIt.designerEmail).bold()
        }
        HStack {
            Text("Game Played").bold()
            Divider()
            Text(CloseIt.relativeDateAsSring(date: control.resources.startDatePlayed))
            Text("-")
            Text(CloseIt.relativeDateAsSring(date: control.resources.endDatePlayed))
        }
        HStack {
            Text("Number of Days Played").bold()
            Divider()
            Text(control.numDaysPlayed.description)
        }
        HStack {
            Text("Language").bold()
            Divider()
            Text(Locale.current.languageCode!)
        }
        HStack {
            Text("reset").bold()
            Divider()
            Text("\(CloseItControl.Application.reset)")
        }
        HStack {
            Text("admin").bold()
            Divider()
            Text("\(control.applicationAdmin)")
        }
        HStack {
            Text("debug").bold()
            Divider()
            Text("\(control.applicationDebug)")
        }
    }
}

struct CloseItAdminInfoView: View {
    @EnvironmentObject var control: CloseItControl
    @State var showNames: Bool

    var body: some View {
            List {
                HStack {
                    Text("Info").font(.title).bold()
                }
                CloseItInfoVarView()
                CloseItInfoConfigView(config: control.resources.config, showNames: $showNames)
                CloseItInfoFeaturesView(showNames: $showNames)
                CloseItInfoControlView(control: control, showNames: $showNames)
                CloseItInfoDesignsView(showNames: $showNames)
                CloseItInfoLevelsView(showNames: $showNames)
                CloseItInfoPlayerView(player: control.resources.player, showNames: $showNames)
                CloseItInfoUsersView(showNames: $showNames)
                CloseItInfoDemosView(title: "Demos", demos: control.resources.demos, showNames: $showNames)
                CloseItInfoGamesView(title: "Demo Games", games: control.resources.demoGames, showNames: $showNames)
                CloseItInfoBoardsView(title: "Boards", dataBoards: control.resources.dataBoards, showNames: $showNames)
                CloseItAdminInfoChallengesView(title: "Challenges", dataChallenges: control.resources.dataChallenges, showNames: $showNames)
                CloseItAdminInfoAchievementsView(title: "Target Achievements", achivements: control.resources.targetAchievements, showNames: $showNames)
                CloseItAdminInfoAchievementsView(title: "User Achievements", achivements: control.resources.userAchievements, showNames: $showNames)
                CloseItInfoGamesView(title: "Games (done)", games: control.resources.doneGames, showNames: $showNames)
                CloseItInfoScoresView(showNames: $showNames)
                CloseItInfoIncidentsView(showNames: $showNames)
            }
            .toolbar {
                HStack {
                    Button(action: { showNames.toggle(); control.resources.dataControl.store() }) {
                        Text((showNames ? "Hide" : "Show") + " Names").bold()
                    }
                }
            }
        }
}
