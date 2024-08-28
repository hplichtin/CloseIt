//
//  CloseItGameView.swift
//  CloseIt
//
//  Created by Hans-Peter Lichtin on 18.09.21.
//

import SwiftUI

struct CloseItGameView: View {
    var control: CloseItControl
    var design: CloseItDesign
    var game: CloseItGame
    @Binding var controlZoom: Double
    @Binding var shapeSize: Bool
    @Binding var controlDebug: Bool
    var resize: Bool = false
    var enable: Bool
    var showHelpAlways: Bool

    var body: some View {
        GeometryReader { geoGameView in
            List {
                CloseItGameScoreListView(game: game)
                CloseItBoardView(control: control, design: design, game: game, maxSize: geoGameView.size, resize: resize, controlZoom: $controlZoom, shapeSize: $shapeSize, enable: enable, showHelpAlways: showHelpAlways, controlDebug: $controlDebug)
                if controlDebug {
                    CloseItDebugTextView()
                    if #available(iOS 15.0, *) {
                        let _ = Self._printChanges()
                    }
                    Text("geoGameView.size.width: \(geoGameView.size.width) geoGameView.size.height: \(geoGameView.size.height)")
                    Text("game.id: \(game.id)")
                    HStack {
                        Text("game.mode: \(game.mode)")
                        Text("game.isProcessing: \(game.isProcessing)")
                    }
                    HStack {
                        Text("game.isFinished: \(game.isFinished)")
                        Text("game.isDisabled: \(game.isDisabled)")
                        Text("game.isAutoClose: \(game.isAutoClose)")
                    }
                    HStack {
                        Text("game.isFirstAction: \(game.isFirstAction)")
                        Text("game.isLastAction: \(game.isLastAction)")
                    }
                    Text("game.userId: \(game.userId)")
                    Text("game.myScore.id: " + (game.myScore == nil ? "nil" : "\(game.myScore!.id)"))
                    Text("game.myScore.userId: \(game.myScore == nil ? "nil" : game.myScore!.userId)")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
