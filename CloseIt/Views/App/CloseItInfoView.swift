//
//  CloseItStartView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.09.21.
//

import SwiftUI

struct CloseItInfoGroupGamesChallenqeView: View {
    @EnvironmentObject var control: CloseItControl
    var level: CloseItLevel
    var gData: CloseItGamesGroup.Data

    var body: some View {
        let groupText = gData.groupName
        let availableText:LocalizedStringKey = "available"
        
        ForEach(gData.games.data.filter { $0.game.board.level == level.level }) { dGame in
            HStack {
                Image(systemName: CloseItControl.getChallengeImageName(isCompleted: gData.games.achievedObjects.num > 0 && gData.games.achievedObjects.completed))
                Divider()
                Text(groupText)
                Divider()
                Image(systemName: CloseItControl.getChallengeImageName(isCompleted: dGame.achievedObjects.num > 0 && dGame.achievedObjects.completed))
                Divider()
                Text(dGame.game.board.boardName)
                Divider()
                Text(dGame.game.board.challenge)
                if dGame.game.board.availableAfterDays > 0 {
                    let available = control.availableAt(numDays: dGame.game.board.availableAfterDays)
                    if available > Date() {
                        Divider()
                        Text(availableText)
                        Text(CloseIt.relativeDateAsSring(date: available))
                    }
                }
            }
        }
    }
}

struct CloseItInfoLevelChallengesView: View {
    @EnvironmentObject var control: CloseItControl
    var level: CloseItLevel
    var group: CloseItGamesGroup
    var title: String
    @State var isCollapsed = false
    
    var body: some View {
        let levelText:LocalizedStringKey = "Level"
        let notText:LocalizedStringKey = "has not yet been achieved"

        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Image(systemName: CloseItControl.getChallengeImageName(isCompleted: level.level <= control.applicationLevel))
            Divider()
            Text(levelText).font(.title3).bold()
            Divider()
            Text("\(level.level)").font(.title3)
            Divider()
            if level.level <= control.applicationLevel || control.applicationAdmin {
                Text(level.levelName).font(.title2).bold()
                Divider()
                Text(level.levelDescription).font(.title3).bold()
            }
            else {
                Text(notText).font(.title3).bold().opacity(0.3)
            }
        }
        /*if level.level == control.applicationLevel {
            CloseItAchievementsView(name: title, group: group.achievedGroups, objects: group.achievedObjects, games: group.achievedScores)
        }*/
        if !isCollapsed {
            if level.level <= control.applicationLevel || control.applicationAdmin {
                ForEach(group.data.filter { $0.hasGames(level: level.level, numDaysPlayed: control.numDaysPlayed) }) { data in
                    CloseItInfoGroupGamesChallenqeView(level: level, gData: data)
                }
            }
        }
    }
}

struct CloseItInfoChallengesView: View {
    @EnvironmentObject var control: CloseItControl
    var title: String
    var group: CloseItGamesGroup
    
    var body: some View {
        let titleText:LocalizedStringKey = LocalizedStringKey(title)
        
        List {
            Text(titleText).font(.title).bold()
                ForEach(control.resources.levels.levels) { level in
                CloseItInfoLevelChallengesView(level: level, group: group, title: title)
            }
        }
    }
}

struct CloseItInfoAchievementObjectView: View {
    @EnvironmentObject var control: CloseItControl
    var admin: Bool
    var achievement: CloseItAchievement
    let imageSize = 25.0
    
    var numAchievements: Int {
        var num = control.numAchievementCompleted(achievement: achievement)
        if num > achievement.achievementValue {
            num = achievement.achievementValue
        }
        return num
    }
    
    var body: some View {
        let notText:LocalizedStringKey = "not yet been disclosed"

        HStack {
            Image(systemName: CloseItControl.getChallengeImageName(isCompleted: achievement.achieved))
            if achievement.achieved {
                Divider()
                Text(CloseIt.relativeDateAsSring(date: achievement.data.achievementDate))
                Divider()
            }
            Text(achievement.achievementTypeName)
            Divider()
            if achievement.achieved || achievement.nextUserAchievement || admin {
                if achievement.achievementType != .allChallengesAtLevelCompleted {
                    Text("\(numAchievements)")
                    Text("/")
                    Text("\(achievement.achievementValue)")
                    Text("=")
                    
                    let percentage = String(format: "%.0f", (Float(numAchievements) / Float(achievement.achievementValue) * 100))
                    Text("\(percentage)%")
                }
                else {
                    let level = control.getLevel(level: achievement.achievementValue)
                    
                    Text("\(level.level)")
                    Divider()
                    Text(level.levelName)
                }
                Divider()
                if UIImage(named: achievement.badgeImageName) != nil {
                    Image(achievement.badgeImageName)
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                }
                else {
                    Text(achievement.badgeImageName)
                }
            }
            else {
                Text(notText).font(.title3).bold().opacity(0.3)
            }
        }
    }
}

struct CloseItInfoAchievementTypeView: View {
    @EnvironmentObject var control: CloseItControl
    var targetAchievements: CloseItAchievements
    var achievementType: CloseItAchievementType
    @State var isCollapsed = false
    let imageSize = 25.0
    
    var body: some View {
        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(CloseItAchievement.getAchievementTypeName(achievementType: achievementType)).font(.title3).bold()
        }
        if !isCollapsed {
            ForEach(targetAchievements.objects.filter { $0.achievementType == achievementType } ) { obj in
                CloseItInfoAchievementObjectView(admin: control.applicationAdmin, achievement: obj)
                /* HStack {
                    Image(systemName: CloseItControl.getChallengeImageName(isCompleted: obj.achieved))
                    Text(obj.achievementTypeName)
                    Divider()
                    if obj.achieved || obj.nextUserAchievement || control.applicationAdmin {
                        if achievementType != .allChallengesAtLevelCompleted {
                            let num = numAchieved(achievement: obj)
                            
                            Text("\(num)")
                            Text("/")
                            Text("\(obj.achievementValue)")
                            Text("=")
                            
                            let percentage = String(format: "%.0f", (Float(num) / Float(obj.achievementValue) * 100))
                            Text("\(percentage)%")
                        }
                        else {
                            let level = control.getLevel(level: obj.achievementValue)
                            
                            Text("\(level.level)")
                            Divider()
                            Text(level.levelName)
                        }
                        Divider()
                        if UIImage(named: obj.badgeImageName) != nil {
                            Image(obj.badgeImageName)
                                .resizable()
                                .frame(width: imageSize, height: imageSize)
                        }
                        else {
                            Text(obj.badgeImageName)
                        }
                    }
                    else {
                        Text(notText).font(.title3).bold().opacity(0.3)
                    }
                } */
            }
        }
    }
}

struct CloseItInfoGoalsView: View {
    @EnvironmentObject var control: CloseItControl
    var title: String
    var achievements: CloseItAchievements
    @State var isCollapsed = false
    
    var body: some View {
        let titleText:LocalizedStringKey = LocalizedStringKey(title)
        let goalsText:LocalizedStringKey = "Goals"
        let accomplishedText:LocalizedStringKey = "accomplished"
        let ofText:LocalizedStringKey = "of"

        List {
            Text(titleText).font(.title).bold()
            HStack {
                Text(goalsText).bold()
                Divider()
                Text(accomplishedText)
                Text("\(achievements.getNumAchieved(userId: control.applicationCurrentUser!.id))")
                Divider()
                Text(ofText)
                Text("\(achievements.count)")
            }
            ForEach(CloseItAchievementType.allCases, id: \.self) { at in
                CloseItInfoAchievementTypeView(targetAchievements: achievements, achievementType: at)
            }
        }
    }
}

struct CloseItInfoAchievementsView: View {
    @EnvironmentObject var control: CloseItControl
    var title: String
    var user: CloseItUser
    var achievements: CloseItAchievements
    var numAchievments: Int
    @State var isCollapsed = false
    
    func totalAchievements (a1: CloseItAchievementGames, a2: CloseItAchievementGames) -> CloseItAchievementGames {
        var a = a1
        a += a2
        return a
    }
    
    var body: some View {
        if !control.applicationBusy {
            let titleText:LocalizedStringKey = LocalizedStringKey(title)
            let goalsText:LocalizedStringKey = "Goals"
            let accomplishedText:LocalizedStringKey = "accomplished"
            let ofText:LocalizedStringKey = "of"
            
            List {
                Text(titleText).font(.title).bold()
                HStack {
                    Text(goalsText).bold()
                    Divider()
                    Text(accomplishedText)
                    Text("\(achievements.getNumAchieved(userId: user.id))")
                    Divider()
                    Text(ofText)
                    Text("\(numAchievments)")
                }
                ForEach(achievements.objects.filter { $0.userId == user.id }) { achievement in
                    CloseItInfoAchievementObjectView(admin: control.applicationAdmin, achievement: achievement)
                }
                Divider()
                CloseItLevelView(level: user.level)
                CloseItAchievementsView(name: "Challenges", group: control.resources.challengeGames.achievedGroups, objects: control.resources.challengeGames.achievedObjects, games: control.resources.challengeGames.achievedScores)
                Divider()
                CloseItAchievementsView(name: "Boards", group: control.resources.boardGames.achievedGroups, objects: control.resources.boardGames.achievedObjects, games: control.resources.boardGames.achievedScores)
                Divider()
                let achievedGames = totalAchievements(a1: control.resources.challengeGames.achievedScores, a2: control.resources.boardGames.achievedScores)
                HStack {
                    CloseItAchievementGamesView(name: "Total", games: achievedGames)
                }
                HStack {
                    HStack {
                        CloseItAchievementGamesDataView(name: "Total", games: achievedGames)
                    }
                }
            }
        }
    }
}

struct CloseItInfoView: View {
    @EnvironmentObject var control: CloseItControl
    var title: LocalizedStringKey
    @State var isCollapsed: Bool = false
    
    var num: Int {
        return control.resources.levels.count
    }

    var body: some View {
        let introductionText:LocalizedStringKey = "Introduction"
        let challenges = "Challenges"
        let challengesText:LocalizedStringKey = LocalizedStringKey(challenges)
        let goals = "Goals"
        let goalsText:LocalizedStringKey = LocalizedStringKey(goals)
        let achievements = "Achievements"
        let achievementsText:LocalizedStringKey = LocalizedStringKey(achievements)
        let acknowledgements = "Acknowledgements"
        let acknowledgementsText:LocalizedStringKey = LocalizedStringKey(acknowledgements)
        let copyright = "Copyright"
        let copyrightText:LocalizedStringKey = LocalizedStringKey(copyright)

        NavigationView {
            List {
                HStack {
                    CloseItExpandButtonView(isSet: $isCollapsed)
                    Text(introductionText).font(.title2).bold()
                }
                if !isCollapsed {
                    CloseItDemosView()
                }
                NavigationLink(destination: CloseItInfoChallengesView(title: challenges, group: control.resources.challengeGames)) {
                    Text(challengesText).font(.title2).bold()
                }
                NavigationLink(destination: CloseItInfoGoalsView(title: goals, achievements: control.resources.targetAchievements)) {
                    Text(goalsText).font(.title2).bold()
                }
                NavigationLink(destination: CloseItInfoAchievementsView(title: achievements, user: control.applicationCurrentUser!, achievements: control.resources.userAchievements, numAchievments: control.resources.targetAchievements.count)) {
                    Text(achievementsText).font(.title2).bold()
                }
                NavigationLink(destination: CloseItInfoTextsView(title: acknowledgements)) {
                    Text(acknowledgementsText).font(.title2)
               }
                NavigationLink(destination: CloseItInfoTextsView(title: copyright)) {
                    Text(copyrightText).font(.title2)
               }
            }
            .navigationTitle(title)
        }
    }
}
