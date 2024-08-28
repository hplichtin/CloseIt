//
//  CloseItAchievementApplicationView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 14.07.24.
//

import SwiftUI

struct CloseItInfoAchievementView: View {
    @EnvironmentObject var control: CloseItControl
    var achievement: CloseItAchievement
    var isCompleted: Bool
    
    var body: some View {
        HStack {
            Image(systemName: CloseItControl.getChallengeImageName(isCompleted: isCompleted))
            Text(achievement.achievementTypeName)
            Divider()
            if achievement.achievementType != .allChallengesAtLevelCompleted {
                Text("\(achievement.data.achievementValue)")
            }
            else {
                let level = control.getLevel(level: achievement.data.achievementValue)
                
                Text("\(level.level)")
                Divider()
                Text(level.levelName)
                Divider()
                Image(achievement.badgeImageName)
                    .resizable()
                    .frame(width: 25, height: 25)
            }
        }
    }
}

struct CloseItAchievementApplicationView: View {
    @EnvironmentObject var control: CloseItControl
    
    var body: some View {
        let goalText:LocalizedStringKey = "Goal Achieved"
        let congratulationsText:LocalizedStringKey = "Congratulations!"
        

        GeometryReader { geoGameView in
            if control.achievementViewData.hasAchievement {
                List {
                    let achievedText:LocalizedStringKey = "You achieved Goal"
                    let newText:LocalizedStringKey = "You achieved new Level"
                    let availableText:LocalizedStringKey = "New available"
                    let challengesText:LocalizedStringKey = "Challenges"

                    HStack {
                        Button(action: {
                            control.closeAchievementView()
                        }) {
                            Image(systemName: CloseItControl.UserInterface.closeSystemImageName)
                        }
                        Text(goalText).font(.largeTitle).bold()
                    }
                    HStack {
                        Text(congratulationsText).font(.title).bold()
                    }
                    HStack {
                        Text(achievedText)
                        Divider()
                        Text(control.achievementViewData.achievement.achievementTypeName).font(.title2).bold()
                        Divider()
                        Text("\(control.achievementViewData.achievement.achievementValue)")
                        if control.achievementViewData.achievement.achievementType == .allChallengesAtLevelCompleted {
                            let level = control.getLevel(level: control.achievementViewData.achievement.achievementValue)
                            
                            Text(level.levelName).bold()
                            Divider()
                            Text(level.levelDescription).bold()
                        }
                        /*else {
                            Text("/")
                            Text("\(control.achievementViewData.achievement.achievementValue)")
                            Text("100%")
                        }*/

                    }
                    if control.achievementViewData.achievement.achievementType == .allChallengesAtLevelCompleted {
                        HStack {
                            CloseItAchievementGroupView(name: "Challenges", group: control.achievementViewData.oldAchievementGroup)
                        }
                        let oldLevel = control.achievementViewData.achievement.achievementValue
                        if oldLevel < control.getMaxLevel().level {
                            let newLevel = control.getLevel(level: control.achievementViewData.achievement.achievementValue + 1)

                            HStack {
                                Text(newText)
                                Divider()
                                Text("\(newLevel.level)")
                                Divider()
                                Text(newLevel.levelName).bold()
                                Divider()
                                Text(newLevel.levelDescription).bold()
                            }
                            if control.achievementViewData.numNew > 0 {
                                HStack {
                                    Text(availableText)
                                    Divider()
                                    Text("\(control.achievementViewData.numNew)")
                                    Text(challengesText)
                                }
                            }
                        }
                        else {
                            let completedText:LocalizedStringKey = "You completed all levels!"
                            let newChallengesText:LocalizedStringKey = "to get a new version of your CloseIt App!"
                            
                            HStack {
                                Text(completedText)
                            }
                            HStack {
                                CloseItContactView()
                                Divider()
                                Text(newChallengesText)
                            }
                        }
                    }
                    if control.achievementViewData.achievement.achievementType == .numDaysPlayed && control.achievementViewData.numNew > 0 {
                        HStack {
                            Text(availableText)
                            Divider()
                            Text("\(control.achievementViewData.numNew)")
                            Text(challengesText)
                        }
                    }
                    let imageSize = min(geoGameView.size.width, geoGameView.size.height * 0.8)
                    
                    Image(control.achievementViewData.achievement.badgeImageName)
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                }
            }
        }
    }
}
