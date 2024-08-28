//
//  CloseItLevelView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 14.07.2024.
//

import SwiftUI

struct CloseItLevelView: View {
    @EnvironmentObject var control: CloseItControl
    var level: Level
    
    var body: some View {
        let levelText:LocalizedStringKey = "Level"
        
        HStack {
            let level = control.getLevel(level: level)
            let maxLevel = control.getMaxLevel()
            
            Text(levelText).bold()
            Divider()
            Text(level.levelName)
            Divider()
            Text("\(level.level)")
            Divider()
            Text("of")
            Text("\(maxLevel.level)")
        }
    }
}

struct CloseItLevelsView: View {
    @EnvironmentObject var control: CloseItControl
    
    var body: some View {
        let notUnlockedText:LocalizedStringKey = "not unlocked"
        
        List {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(control.resources.levels.levels) { level in
                    HStack(alignment: .top) {
                        Image(systemName: CloseItControl.getCheckImageName(isChecked: level.level <= control.applicationLevel))
                        Divider()
                        Text("\(level.level).")
                        Divider()
                        if (level.level <= control.applicationLevel) {
                            Text(level.levelName).bold()
                            Divider()
                            Text(level.levelDescription)
                        }
                        else {
                            Text(notUnlockedText)
                                .opacity(0.3)
                        }
                    }
                    Divider()
                }
            }
        }
    }
}
