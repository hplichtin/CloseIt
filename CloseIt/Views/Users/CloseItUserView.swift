//
//  CloseItDataUserView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.12.21.
//

import SwiftUI

struct CloseItUserView: View {
    @EnvironmentObject var control: CloseItControl
    @ObservedObject var user: CloseItUser
    @State var sleepSeconds: Double
    
    var userIsCurrent: Bool {
        return control.applicationCurrentUser != nil ? control.applicationCurrentUser!.id == user.id : false
    }

    var body: some View {
        // let achievementText:LocalizedStringKey = "Achievements"
        
        List {
            HStack {
                Text("Data").font(.title2).bold()
            }
            HStack {
                Text("Source").bold()
                Divider()
                Text(user.data.source)
            }
            HStack {
                Text("Id").bold()
                Divider()
                Text(user.data.id)
            }
            HStack {
                Text("Alias").bold()
                Divider()
                TextField("Name", text: $user.data.alias)
                    .disabled(!user.data.isLocal)
            }
            HStack {
                Text("Name").bold()
                Divider()
                TextField("Alias", text: $user.data.name)
                    .disabled(!user.data.isLocal)
            }
            HStack {
                Text("Current User").bold()
                Divider()
                if userIsCurrent || (!user.data.isLocal && user.id != control.resources.player.id) {
                    Image(systemName: CloseItControl.getCurrentUserImageName(isCurrent: true))
                }
                else {
                    Button(action: { control.setCurrentUser(user: user, store: true) }) {
                        Image(systemName: CloseItControl.getCurrentUserImageName(isCurrent: false))
                    }
                }
            }
            Toggle(isOn: $user.data.isAutoClose) {
                Text("Auto Close").bold()
            }
            HStack {
                Text("Sleep Seconds:").bold()
                Text("\(user.data.sleepSeconds, specifier: "%.1f")")
                Slider(value: Binding(
                    get: { self.sleepSeconds },
                    set: { newValue in
                        if self.sleepSeconds != newValue {
                            self.sleepSeconds = newValue
                            user.data.sleepSeconds = self.sleepSeconds
                            if userIsCurrent {
                                control.setSleepSeconds(sleepSeconds: self.sleepSeconds)
                            }
                        }
                    }
                    ), in: 0.0...1.0, step: 0.1)
            }
            /*if userIsCurrent {
                Divider()
                Text(achievementText).font(.title2).bold()
                CloseItLevelView(level: user.level)
                CloseItAchievementsView(name: "Boards", group: control.resources.boardGames.achievedGroups, objects: control.resources.boardGames.achievedObjects, games: control.resources.boardGames.achievedScores)
                CloseItAchievementsView(name: "Challenges", group: control.resources.challengeGames.achievedGroups, objects: control.resources.challengeGames.achievedObjects, games: control.resources.challengeGames.achievedScores)
            }*/
            if control.applicationDebug {
                CloseItDebugTextView()
                Text("control.resources.dataControl.currentUserId: \(control.resources.dataControl.currentUserId)")
                Text("control.resources.player.id: \(control.resources.player.id)")
                Text("control.resources.player.id == control.dataControl.currentUserId: \(control.resources.player.id == control.resources.dataControl.currentUserId)")
                Text("control.resources.users.count: \(control.resources.users.count)")
            }
        }
        .toolbar {
            HStack {
                Button(action: { control.storeUsers() }) {
                    Text("Save")
                }
                Button(action: { control.deleteUser(userId: user.id) }) {
                    Text("Delete")
                        .disabled(userIsCurrent)
                }
            }
        }
    }
}
