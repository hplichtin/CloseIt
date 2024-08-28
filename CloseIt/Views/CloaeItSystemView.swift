//
//  CloaeItSystemView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 24.09.22.
//

import SwiftUI

struct CloaeItSystemView: View {
    @EnvironmentObject var control: CloseItControl
    @State var selectedOption: Level

    var body: some View {
        let levelText:LocalizedStringKey = "Level"
        
        List {
            Button(action: { control.resources.reset(reset: true) }) {
                Text("Reset Application")
            }
            Button(action: { CloseItControl.Resources.doReset(reset: true) }) {
                Text("Delete all stored files!")
            }
            if control.applicationAdmin {
                if control.resources.levels.count > 1 {
                    HStack {
                        Text(levelText).bold()
                        Picker("", selection: $selectedOption) {
                            ForEach(control.resources.levels.levels) { level in
                                Text(level.levelName)
                            }
                        }
                        //.pickerStyle(SegmentedPickerStyle())
                        //.onChange(of: control.applicationLevel) {
                        //    control.setPublishedScores()
                        //}
                        //.onReceive(Just(selectedOption)) { newValue in
                        //    control.setPublishedScores()
                        //}
                    }
                }
            }
            Toggle(isOn: $control.applicationAdmin) {
                Text("Admin").bold()
            }
           Toggle(isOn: $control.applicationDebug) {
                Text("Debug").bold()
            }
            if control.applicationDebug {
                CloseItDebugTextView()
                Text(control.resources.dataControl.value(showName: true))
            }
        }
        .toolbar {
            HStack {
                Button(action: { control.setNewLevelOfCurrenUser(level: selectedOption) }) {
                    Text("Apply")
                }
            }
            HStack {
                Button(action: { control.resources.storeControl() }) {
                    Text("Save")
                }
            }
        }
    }
}
