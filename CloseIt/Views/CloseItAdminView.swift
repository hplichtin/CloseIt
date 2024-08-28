//
//  CloseItAdminView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 16.12.21.
//

import SwiftUI

struct CloseItAdminView: View {
    @EnvironmentObject var control: CloseItControl

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CloseItAdminInfoView(showNames: control.resources.dataControl.showInfoNames)) {
                    Text("Info").bold()
                }
                NavigationLink(destination: CloseItProgramView()) {
                    Text("Program").bold()
                }
                
                let level = control.applicationLevel
                NavigationLink(destination: CloaeItSystemView(selectedOption: level)) {
                    Text("System").bold()
                }
                NavigationLink(destination: CloseItSettingsView()) {
                    Text("Settings").bold()
                }
            }
            .navigationTitle("Admin")
        }
    }
}
