//
//  CloseItSettingsView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 18.06.2024.
//

import SwiftUI

struct CloseItSettingsView: View {
    @EnvironmentObject var control: CloseItControl
    @State var isCollapsed: Bool = true
    @State var shapeSize: Bool = false

    var body: some View {
        List {
            HStack {
                CloseItExpandButtonView(isSet: $isCollapsed)
                Text("Design").bold()
                Divider()
                if control.resources.designs.count > 1 {
                    Picker("", selection: $control.resources.dataControl.designId) {
                        ForEach(control.resources.designs) { design in
                            Text(design.id)
                        }
                    }
                }
                else {
                    Divider()
                    Text(control.resources.dataControl.designId)
                }
            }
            if (!isCollapsed) {
                ForEach(control.resources.designs) { design in
                    HStack {
                        Button(action: { control.resources.dataControl.designId = design.id }) {
                            Image(systemName: CloseItControl.getCheckUserImageName(isCheck: control.resources.dataControl.designId == design.id))
                                .imageScale(.large)
                        }
                        Text(design.id)
                        CloseItBoardView(control: control, design: design, game: CloseItGame.defaultGame(), resize: false, controlZoom: $control.applicationZoom, shapeSize: $shapeSize, enable: false, showHelpAlways: false, controlDebug: $control.applicationDebug)
                    }
                }
            }
        }
        .toolbar {
            HStack {
                Button(action: { control.resources.storeControl() }) {
                    Text("Save")
                }
            }
        }
    }
}
