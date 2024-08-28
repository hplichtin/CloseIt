//
//  CloseItGamesView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 22.11.21.
//

import SwiftUI

struct CloseItGamesView: View {
    @EnvironmentObject var control: CloseItControl
    @State var isCollapsed: Bool = true
    var ggData: CloseItGamesGroup.Data
    @Binding var shapeSize: Bool
    
    var design: CloseItDesign {
        let design = control.getDesign(designId: control.resources.dataControl.designId)
        
        return design
    }
    
    var body: some View {
        let groupText = ggData.groupName

        HStack {
            CloseItExpandButtonView(isSet: $isCollapsed)
            Text(groupText).bold()
            Divider()
            if ggData.games.achievedObjects.num == ggData.games.achievedObjects.numCompleted {
                Image(systemName: CloseItControl.UserInterface.challengeSystemImageName)
            }
            else {
                Image(systemName: CloseItControl.UserInterface.challengeOpenSystemImageName)
            }
        }
        if !isCollapsed {
            let numDaysPlayed = control.numDaysPlayed
            ForEach(ggData.games.data.filter { $0.game.board.level <= control.applicationLevel && $0.game.board.availableAfterDays <= numDaysPlayed}) { gd in
                NavigationLink(destination: CloseItGameView(control: control, design:design, game: gd.game, controlZoom: $control.applicationZoom, shapeSize: $shapeSize, controlDebug: $control.applicationDebug, enable: true, showHelpAlways: false)) {
                    CloseItDataBoardRowView(gData: gd)
                }
            }
        }
    }
}
