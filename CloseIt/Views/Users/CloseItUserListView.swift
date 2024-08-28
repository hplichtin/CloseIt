//
//  CloseItUserListView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 12.12.21.
//

import SwiftUI

struct CloseItUserListView: View {
    @EnvironmentObject var control: CloseItControl
    var title: LocalizedStringKey
    @ObservedObject var users: CloseItUsers

    var body: some View {
        NavigationView {
            List {
                ForEach(users.users) { user in
                    NavigationLink(destination: CloseItUserView(user: user, sleepSeconds: user.sleepSeconds)) {
                        CloseItUserListRowView(user: user)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                HStack {
                    Button(action: {
                        control.newUser()
                    }) {
                        Label("New", systemImage: CloseItControl.UserInterface.newUserSystemImageName)
                    }
                    Button(action: {
                        control.resources.player.authenticate()
                    }) {
                        Text("Login")
                    }
                    .disabled(true)
                    Button(action: {
                        control.resources.player.dashboard()
                    }) {
                        Text("Dashboard")
                    }
                    .disabled(true)
                }
            }
        }
    }
}
